# Memory-Safe Bridges Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Make Julia/C++ bridge pointer handoffs memory safe without changing public behavior or performance characteristics.

**Architecture:** Add scoped helpers around borrowed Julia buffers, preserving arrays with `GC.@preserve` while C++ wrappers and calls use their data pointers. Update call sites to use scoped helpers for `copy=false` and direct pointer fills, while preserving existing copy semantics.

**Tech Stack:** Julia 1.10+, CxxWrap, XDiag_jll C++ wrappers, Julia `Test`.

---

## File Structure

- `src/utils/armadillo.jl`: Owns dense Armadillo conversion helpers and the new internal scoped helpers `with_armadillo` and `unsafe_copy_to_julia!`.
- `src/algebra/sparse/sparse_matrix_types.jl`: Owns sparse matrix structs and the new scoped CSR helper `with_cxx_csr_matrix`.
- `src/algebra/matrix.jl`: Dense matrix generation into Julia-owned arrays.
- `src/algebra/apply.jl`: Dense vector/matrix in-place apply using borrowed Armadillo wrappers.
- `src/algebra/sparse/apply.jl`: Sparse CSR apply using borrowed CSR and Armadillo wrappers.
- `src/algebra/sparse/coo_matrix.jl`, `src/algebra/sparse/csr_matrix.jl`, `src/algebra/sparse/csc_matrix.jl`: Sparse matrix fill and dense conversion pointer handoffs.
- `src/states/state.jl`: State constructors from Julia vector/matrix data.
- `src/symmetries/permutation_group.jl`: Permutation group constructor from Julia matrix data.
- `test/utils/armadillo.jl`: New focused tests for scoped helpers.
- `test/runtests.jl`: Include the new helper tests.

## Task 1: Add Failing Tests for Scoped Borrowed Helpers

**Files:**
- Create: `test/utils/armadillo.jl`
- Modify: `test/runtests.jl`

- [ ] **Step 1: Write the failing tests**

Create `test/utils/armadillo.jl` with:

```julia
# SPDX-FileCopyrightText: 2026 XDiag contributors
#
# SPDX-License-Identifier: Apache-2.0

@testset "armadillo scoped helpers" begin
    block = Spinhalf(2)
    ops = OpSum()
    ops += Op("SdotS", [1, 2])
    dense = matrix(ops, block)

    @testset "with_armadillo preserves zero-copy vector apply semantics" begin
        vin = [0.0, 1.0, 0.0, 0.0]
        w_existing = zeros(Float64, 4)
        w_scoped = zeros(Float64, 4)

        apply(ops, block, vin, block, w_existing)

        XDiag.with_armadillo(vin; copy=false) do vin_arma
            XDiag.with_armadillo(w_scoped; copy=false) do w_arma
                XDiag.cxx_apply(ops.cxx_opsum, block.cxx_block, vin_arma,
                                block.cxx_block, w_arma)
            end
        end

        @test w_scoped == w_existing
        @test w_scoped ≈ dense * vin
    end

    @testset "with_armadillo preserves zero-copy matrix apply semantics" begin
        min = [0.0 1.0; 1.0 0.0; 0.0 0.0; 0.0 0.0]
        mout_existing = zeros(Float64, 4, 2)
        mout_scoped = zeros(Float64, 4, 2)

        apply(ops, block, min, block, mout_existing)

        XDiag.with_armadillo(min; copy=false) do min_arma
            XDiag.with_armadillo(mout_scoped; copy=false) do mout_arma
                XDiag.cxx_apply(ops.cxx_opsum, block.cxx_block, min_arma,
                                block.cxx_block, mout_arma)
            end
        end

        @test mout_scoped == mout_existing
        @test mout_scoped ≈ dense * min
    end

    @testset "with_cxx_csr_matrix preserves CSR dense conversion" begin
        csr = csr_matrix(ops, block)
        scoped_dense = XDiag.with_cxx_csr_matrix(csr) do cxx_csr
            XDiag.to_julia(XDiag.cxx_to_dense(cxx_csr))
        end

        @test scoped_dense == to_dense(csr)
        @test scoped_dense ≈ dense
    end
end
```

Modify `test/runtests.jl` to include it near the top, after `using XDiag, Test`:

```julia
include("utils/armadillo.jl")
```

- [ ] **Step 2: Run the new test to verify it fails**

Run:

```bash
julia --project=. -e 'using XDiag, Test; include("test/utils/armadillo.jl")'
```

Expected: FAIL with `UndefVarError: with_armadillo not defined` or `UndefVarError: with_cxx_csr_matrix not defined`.

- [ ] **Step 3: Commit the failing tests**

Run:

```bash
git add test/runtests.jl test/utils/armadillo.jl
git commit -m "test: cover scoped bridge helpers"
```

## Task 2: Implement Scoped Dense and CSR Helper Primitives

**Files:**
- Modify: `src/utils/armadillo.jl`
- Modify: `src/algebra/sparse/sparse_matrix_types.jl`

- [ ] **Step 1: Add dense helper implementation**

In `src/utils/armadillo.jl`, replace the file contents with implementations that keep `to_armadillo` behavior and add scoped helpers:

```julia
# SPDX-FileCopyrightText: 2025 Alexander Wietek <awietek@pks.mpg.de>
#
# SPDX-License-Identifier: Apache-2.0

function _armadillo_wrapper(mat::Matrix{Float64}, copy::Bool)
    m, n = size(mat)
    return cxx_arma_mat(pointer(mat), m, n, copy, true)
end

function _armadillo_wrapper(mat::Matrix{ComplexF64}, copy::Bool)
    m, n = size(mat)
    return cxx_arma_cx_mat(pointer(mat), m, n, copy, true)
end

function _armadillo_wrapper(vec::Vector{Float64}, copy::Bool)
    return cxx_arma_vec(pointer(vec), length(vec), copy, true)
end

function _armadillo_wrapper(vec::Vector{ComplexF64}, copy::Bool)
    return cxx_arma_cx_vec(pointer(vec), length(vec), copy, true)
end

function to_armadillo(array::Union{Matrix{Float64},Matrix{ComplexF64},Vector{Float64},Vector{ComplexF64}}; copy=true)
    GC.@preserve array begin
        return _armadillo_wrapper(array, copy)
    end
end

function with_armadillo(f::F, array::Union{Matrix{Float64},Matrix{ComplexF64},Vector{Float64},Vector{ComplexF64}}; copy=true) where F
    GC.@preserve array begin
        return f(_armadillo_wrapper(array, copy))
    end
end

function _unsafe_copy_to_julia!(dest::Vector{T}, src, n::Integer) where T
    GC.@preserve dest src begin
        Base.unsafe_copyto!(pointer(dest), memptr(src).cpp_object, n)
    end
    return dest
end

function _unsafe_copy_to_julia!(dest::Matrix{T}, src, n::Integer) where T
    GC.@preserve dest src begin
        Base.unsafe_copyto!(pointer(dest), memptr(src).cpp_object, n)
    end
    return dest
end

function to_julia(vec::cxx_arma_vec)
    m = n_rows(vec)
    return _unsafe_copy_to_julia!(Vector{Float64}(undef, m), vec, m)
end

function to_julia(vec::cxx_arma_cx_vec)
    m = n_rows(vec)
    return _unsafe_copy_to_julia!(Vector{ComplexF64}(undef, m), vec, m)
end

function to_julia(mat::cxx_arma_mat)
    m = n_rows(mat)
    n = n_cols(mat)
    return _unsafe_copy_to_julia!(Matrix{Float64}(undef, m, n), mat, n_elem(mat))
end

function to_julia(mat::cxx_arma_cx_mat)
    m = n_rows(mat)
    n = n_cols(mat)
    return _unsafe_copy_to_julia!(Matrix{ComplexF64}(undef, m, n), mat, n_elem(mat))
end
```

- [ ] **Step 2: Add CSR scoped helper implementation**

In `src/algebra/sparse/sparse_matrix_types.jl`, replace the four `to_cxx_csr_matrix` methods with:

```julia
function _cxx_csr_matrix_wrapper(mat::CSRMatrix{Int64,Float64})
    return cxx_create_csr_matrix(mat.nrows, mat.ncols, Int64(size(mat.data, 1)),
                                 pointer(mat.rowptr), pointer(mat.col), pointer(mat.data),
                                 Int64(mat.i0), mat.ishermitian)
end

function _cxx_csr_matrix_wrapper(mat::CSRMatrix{Int64,ComplexF64})
    return cxx_create_csr_matrix(mat.nrows, mat.ncols, Int64(size(mat.data, 1)),
                                 pointer(mat.rowptr), pointer(mat.col), pointer(mat.data),
                                 Int64(mat.i0), mat.ishermitian)
end

function _cxx_csr_matrix_wrapper(mat::CSRMatrix{Int32,Float64})
    return cxx_create_csr_matrix(mat.nrows, mat.ncols, Int64(size(mat.data, 1)),
                                 pointer(mat.rowptr), pointer(mat.col), pointer(mat.data),
                                 Int32(mat.i0), mat.ishermitian)
end

function _cxx_csr_matrix_wrapper(mat::CSRMatrix{Int32,ComplexF64})
    return cxx_create_csr_matrix(mat.nrows, mat.ncols, Int64(size(mat.data, 1)),
                                 pointer(mat.rowptr), pointer(mat.col), pointer(mat.data),
                                 Int32(mat.i0), mat.ishermitian)
end

function to_cxx_csr_matrix(mat::CSRMatrix)
    GC.@preserve mat mat.rowptr mat.col mat.data begin
        return _cxx_csr_matrix_wrapper(mat)
    end
end

function with_cxx_csr_matrix(f::F, mat::CSRMatrix) where F
    GC.@preserve mat mat.rowptr mat.col mat.data begin
        return f(_cxx_csr_matrix_wrapper(mat))
    end
end
```

- [ ] **Step 3: Run helper tests to verify they pass**

Run:

```bash
julia --project=. -e 'using XDiag, Test; include("test/utils/armadillo.jl")'
```

Expected: PASS.

- [ ] **Step 4: Commit helper implementation**

Run:

```bash
git add src/utils/armadillo.jl src/algebra/sparse/sparse_matrix_types.jl
git commit -m "fix: add scoped bridge helpers"
```

## Task 3: Update Dense Bridges to Use Scoped Preservation

**Files:**
- Modify: `src/algebra/matrix.jl`
- Modify: `src/algebra/apply.jl`
- Modify: `src/states/state.jl`
- Modify: `src/symmetries/permutation_group.jl`

- [ ] **Step 1: Update dense matrix generation**

In `src/algebra/matrix.jl`, wrap fill calls with `GC.@preserve` and `pointer(mat)`:

```julia
GC.@preserve mat begin
    cxx_matrix(pointer(mat), ops.cxx_opsum, block_in.cxx_block, block_out.cxx_block)
end
```

and for complex:

```julia
GC.@preserve mat begin
    cxx_matrixC(pointer(mat), ops.cxx_opsum, block_in.cxx_block, block_out.cxx_block)
end
```

- [ ] **Step 2: Update dense apply borrowed wrappers**

In `src/algebra/apply.jl`, replace each `copy=false` direct call with nested scoped helpers. Example for real vectors:

```julia
with_armadillo(vec_in; copy=false) do vec_in_arma
    with_armadillo(vec_out; copy=false) do vec_out_arma
        cxx_apply(ops.cxx_opsum,
                  block_in.cxx_block, vec_in_arma,
                  block_out.cxx_block, vec_out_arma)
    end
end
```

Apply the same pattern to complex vectors, real matrices, and complex matrices.

- [ ] **Step 3: Update State constructors**

Use `GC.@preserve` and `pointer` for vector and matrix constructors. Example:

```julia
GC.@preserve vec begin
    return State(construct_State(block.cxx_block, pointer(vec), 1, 1))
end
```

Apply the analogous pattern to complex vector, real matrix, and complex matrix constructors.

- [ ] **Step 4: Update PermutationGroup matrix constructor**

Use:

```julia
GC.@preserve matrix0 begin
    return PermutationGroup(construct_PermutationGroup(pointer(matrix0), m, n))
end
```

- [ ] **Step 5: Run targeted dense tests**

Run:

```bash
julia --project=. -e 'using XDiag, Test; include("test/utils/armadillo.jl"); include("test/algebra/apply.jl"); include("test/states/state.jl"); include("test/symmetries/symmetries.jl")'
```

Expected: PASS.

- [ ] **Step 6: Commit dense bridge updates**

Run:

```bash
git add src/algebra/matrix.jl src/algebra/apply.jl src/states/state.jl src/symmetries/permutation_group.jl
git commit -m "fix: preserve dense bridge buffers"
```

## Task 4: Update Sparse Matrix Fill and Conversion Bridges

**Files:**
- Modify: `src/algebra/sparse/coo_matrix.jl`
- Modify: `src/algebra/sparse/csr_matrix.jl`
- Modify: `src/algebra/sparse/csc_matrix.jl`
- Modify: `src/algebra/sparse/apply.jl`

- [ ] **Step 1: Update sparse fill calls**

For every `cxx_*_matrix_fill` call, wrap all Julia vectors passed as pointers in `GC.@preserve` and use `pointer(...)`. Example for CSR real fill:

```julia
GC.@preserve n_elements_in_row rowptr col data begin
    cxx_csr_matrix_fill(ops.cxx_opsum, block_in.cxx_block, block_out.cxx_block,
                        nnz, n_elements_in_row,
                        pointer(rowptr), pointer(col), pointer(data),
                        i0, false)
end
```

Apply the same pattern to COO, CSR, and CSC real/complex Int64/Int32 fill paths.

- [ ] **Step 2: Update COO and CSC dense conversions**

For each `to_dense` method that constructs a C++ COO or CSC wrapper, preserve `mat` and its backing arrays and use `pointer(...)`. Example:

```julia
GC.@preserve mat mat.row mat.col mat.data begin
    cxx_spmat = cxx_create_coo_matrix(mat.nrows, mat.ncols, Int64(size(mat.data, 1)),
                                      pointer(mat.row), pointer(mat.col), pointer(mat.data),
                                      Int64(mat.i0), mat.ishermitian)
    return to_julia(cxx_to_dense(cxx_spmat))
end
```

- [ ] **Step 3: Update CSR dense conversions**

In `src/algebra/sparse/csr_matrix.jl`, replace each `to_cxx_csr_matrix` direct conversion with:

```julia
with_cxx_csr_matrix(mat) do cxx_spmat
    return to_julia(cxx_to_dense(cxx_spmat))
end
```

- [ ] **Step 4: Update sparse apply borrowed wrappers**

In `src/algebra/sparse/apply.jl`, replace direct borrowed wrapper calls with scoped nested helpers. For return-producing vector apply:

```julia
with_cxx_csr_matrix(mat) do cxx_mat
    with_armadillo(v; copy=false) do v_arma
        return to_julia(cxx_apply(cxx_mat, v_arma))
    end
end
```

For in-place vector apply:

```julia
with_cxx_csr_matrix(mat) do cxx_mat
    with_armadillo(v; copy=false) do v_arma
        with_armadillo(w; copy=false) do w_arma
            return cxx_apply(cxx_mat, v_arma, w_arma)
        end
    end
end
```

Apply the same pattern to all vector and matrix sparse apply methods.

- [ ] **Step 5: Run targeted sparse tests**

Run:

```bash
julia --project=. -e 'using XDiag, Test; include("test/utils/armadillo.jl"); include("test/algebra/sparse/coo_matrix.jl"); include("test/algebra/sparse/csr_matrix.jl"); include("test/algebra/sparse/csc_matrix.jl"); include("test/algebra/sparse/apply.jl")'
```

Expected: PASS.

- [ ] **Step 6: Commit sparse bridge updates**

Run:

```bash
git add src/algebra/sparse/coo_matrix.jl src/algebra/sparse/csr_matrix.jl src/algebra/sparse/csc_matrix.jl src/algebra/sparse/apply.jl
git commit -m "fix: preserve sparse bridge buffers"
```

## Task 5: Verify No Unsafe Array Handoffs Remain and Run Full Tests

**Files:**
- No source edits expected unless verification finds missed handoffs.

- [ ] **Step 1: Search for old unsafe array pointer conversions**

Run:

```bash
rg -n 'Base\.unsafe_convert\(Ptr' src
```

Expected: no output for the scoped source files. If output remains, replace the occurrence with `GC.@preserve` plus `pointer(...)` and rerun targeted tests.

- [ ] **Step 2: Run targeted bridge test set**

Run:

```bash
julia --project=. -e 'using XDiag, Test; include("test/utils/armadillo.jl"); include("test/operators/op.jl"); include("test/operators/opsum.jl"); include("test/states/state.jl"); include("test/algebra/apply.jl"); include("test/algebra/sparse/coo_matrix.jl"); include("test/algebra/sparse/csr_matrix.jl"); include("test/algebra/sparse/csc_matrix.jl"); include("test/algebra/sparse/apply.jl"); include("test/symmetries/symmetries.jl"); include("test/blocks/blocks.jl")'
```

Expected: PASS.

- [ ] **Step 3: Run full package tests**

Run:

```bash
julia --project=. -e 'using Pkg; Pkg.test()'
```

Expected: PASS.

- [ ] **Step 4: Confirm no performance-changing copies were added**

Run:

```bash
git diff main...HEAD -- src | rg -n 'copy=false|copy=true|copy\(|deepcopy|collect\('
```

Expected: only existing `copy=false`/`copy=true` semantics and helper signatures; no new `copy(...)`, `deepcopy(...)`, or `collect(...)` around bridge buffers.

- [ ] **Step 5: Commit verification-only fixes if any**

If Step 1 required fixes, run:

```bash
git add src test
git commit -m "fix: complete bridge preservation sweep"
```

If no fixes were needed, do not create an empty commit.
