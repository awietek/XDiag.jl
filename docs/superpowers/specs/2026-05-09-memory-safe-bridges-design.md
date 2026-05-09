# Memory-Safe Julia/C++ Bridges Design

## Goal

Make the Julia-to-C++ pointer bridge code memory safe without changing performance characteristics. The fix must not force extra copies, remove zero-copy paths, or change public API behavior.

## Scope

The branch covers the two files originally reported as unsafe and the same bridge pattern in nearby code:

- `src/utils/armadillo.jl`
- `src/algebra/matrix.jl`
- `src/algebra/apply.jl`
- `src/algebra/sparse/apply.jl`
- `src/algebra/sparse/sparse_matrix_types.jl`
- `src/algebra/sparse/coo_matrix.jl`
- `src/algebra/sparse/csr_matrix.jl`
- `src/algebra/sparse/csc_matrix.jl`
- `src/states/state.jl`
- `src/symmetries/permutation_group.jl`

## Approach

Use Julia's idiomatic pointer discipline:

- Use `pointer(array)` instead of standalone `Base.unsafe_convert(Ptr{T}, array)` for array data pointers.
- Wrap every C++ call that consumes Julia-owned array memory in `GC.@preserve` covering the arrays whose pointers are passed.
- Preserve destination Julia arrays and source C++ wrapper objects during `unsafe_copyto!` when copying C++ buffers back to Julia arrays.
- Keep borrowed Armadillo and sparse wrappers scoped to the C++ call that uses them. Do not return long-lived Julia-owned wrapper state for borrowed memory.

## Performance Constraint

The implementation is performance-neutral by design:

- `copy=false` paths remain zero-copy.
- Existing copied paths continue to copy exactly as before.
- No new heap copies are introduced for dense apply, sparse apply, state construction, sparse matrix creation, matrix generation, or `to_dense`.
- The only additional work is lifetime preservation with `GC.@preserve`, which is a correctness annotation for Julia's GC and does not copy data.

## Helper Boundaries

Add small internal helpers in `src/utils/armadillo.jl`:

- `with_armadillo(array; copy, f)` creates a C++ Armadillo wrapper from an array pointer, preserves the array while `f(wrapper)` runs, and returns `f`'s result.
- `with_cxx_csr_matrix(mat, f)` creates a borrowed C++ CSR wrapper, preserves `rowptr`, `col`, and `data` while `f(wrapper)` runs, and returns `f`'s result.

Existing `to_armadillo` and `to_cxx_csr_matrix` may remain for owned/copying or backward-compatible call sites, but borrowed `copy=false` usages in this scope should prefer scoped helpers.

## Testing

Add focused tests that verify the new scoped helper API preserves existing behavior:

- Armadillo vector and matrix helpers can be used with `copy=false` to call existing C++ operations and produce the same results as current public APIs.
- CSR helper can be used to call dense conversion without changing output.

Run targeted bridge tests and the full package test suite.

## Acceptance Criteria

- No `Base.unsafe_convert(Ptr{...}, array)` remains in the scoped source files.
- Pointer handoffs to C++ are inside `GC.@preserve` blocks for the relevant Julia arrays.
- Existing public tests continue to pass.
- The branch contains no forced-copy performance change.
