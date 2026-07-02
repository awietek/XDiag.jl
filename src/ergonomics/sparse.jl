# SPDX-License-Identifier: Apache-2.0
# Hand-written ergonomic layer: run apply / algorithms on a Julia CSRMatrix by
# reconstructing a C++ CSRMatrix object (cxx_make_csr_*) for the duration of the
# call. The cxx_ CSR object machinery is registered in specials_sparse.cpp.

# with_cxx_csr_matrix(f, m): build the cxx CSR, keep the Julia arrays alive, run
# f(cxx_csr). One method per (idx, coeff) combo (distinct cxx_make_csr_* names).
for (IT, CT, sfx) in ((Int64, Float64, "i64f64"), (Int32, Float64, "i32f64"),
                      (Int64, ComplexF64, "i64cx"), (Int32, ComplexF64, "i32cx"))
    mk = Symbol("cxx_make_csr_", sfx)
    @eval function with_cxx_csr_matrix(f, m::CSRMatrix{$IT,$CT})
        GC.@preserve m begin
            cm = $mk(m.nrows, m.ncols, pointer(m.rowptr), length(m.rowptr),
                     pointer(m.col), length(m.col), pointer(m.data),
                     length(m.data), m.i0, m.ishermitian)
            return f(cm)
        end
    end
end

# --- apply --------------------------------------------------------------
function apply(m::CSRMatrix, v::AbstractVecOrMat)
    return with_cxx_csr_matrix(m) do cm
        with_armadillo(v; copy = false) do va
            return to_julia(cxx_apply(cm, va))
        end
    end
end
function apply(m::CSRMatrix, v::AbstractVecOrMat, w::AbstractVecOrMat)
    with_cxx_csr_matrix(m) do cm
        with_armadillo(v; copy = false) do va
            with_armadillo(w; copy = false) do wa
                cxx_apply(cm, va, wa)
            end
        end
    end
    return w
end

# --- diagonalization ----------------------------------------------------
eigval0(m::CSRMatrix, block::Block; precision::Float64 = 1e-12,
        max_iterations::Int64 = 1000, random_seed::Int64 = 42)::Float64 =
    with_cxx_csr_matrix(m) do cm
        cxx_eigval0(cm, block.cxx_block, precision, max_iterations, random_seed)
    end

function eig0(m::CSRMatrix, block::Block; precision::Float64 = 1e-12,
              max_iterations::Int64 = 1000, random_seed::Int64 = 42)
    return with_cxx_csr_matrix(m) do cm
        e0, psi = cxx_eig0(cm, block.cxx_block, precision, max_iterations,
                           random_seed)
        return Float64(e0), State(psi)
    end
end

function eigs(m::CSRMatrix, block::Block; neigs::Int64 = 1,
              precision::Float64 = 1e-12, max_iterations::Int64 = 1000,
              random_seed::Int64 = 42)
    return with_cxx_csr_matrix(m) do cm
        es, psis = cxx_eigs(cm, block.cxx_block, neigs, precision,
                            max_iterations, random_seed)
        return to_julia(es), State(psis)
    end
end

eigs_lanczos(m::CSRMatrix, block::Block; neigvals::Int64 = 1,
             precision::Float64 = 1e-12, max_iterations::Int64 = 1000,
             deflation_tol::Float64 = 1e-7,
             random_seed::Int64 = 42)::EigsLanczosResult =
    with_cxx_csr_matrix(m) do cm
        cxx_eigs_lanczos(cm, block.cxx_block, neigvals, precision,
                         max_iterations, deflation_tol, random_seed)
    end

eigs_lanczos(m::CSRMatrix, psi0::State; neigvals::Int64 = 1,
             precision::Float64 = 1e-12, max_iterations::Int64 = 1000,
             deflation_tol::Float64 = 1e-7)::EigsLanczosResult =
    with_cxx_csr_matrix(m) do cm
        cxx_eigs_lanczos(cm, psi0.cxx_state, neigvals, precision,
                         max_iterations, deflation_tol)
    end

eigvals_lanczos(m::CSRMatrix, block::Block; neigvals::Int64 = 1,
                precision::Float64 = 1e-12, max_iterations::Int64 = 1000,
                deflation_tol::Float64 = 1e-7,
                random_seed::Int64 = 42)::EigvalsLanczosResult =
    with_cxx_csr_matrix(m) do cm
        cxx_eigvals_lanczos(cm, block.cxx_block, neigvals, precision,
                            max_iterations, deflation_tol, random_seed)
    end

eigvals_lanczos(m::CSRMatrix, psi0::State; neigvals::Int64 = 1,
                precision::Float64 = 1e-12, max_iterations::Int64 = 1000,
                deflation_tol::Float64 = 1e-7)::EigvalsLanczosResult =
    with_cxx_csr_matrix(m) do cm
        cxx_eigvals_lanczos(cm, psi0.cxx_state, neigvals, precision,
                            max_iterations, deflation_tol)
    end

eigvals_lanczos_inplace(m::CSRMatrix, psi0::State; neigvals::Int64 = 1,
                        precision::Float64 = 1e-12,
                        max_iterations::Int64 = 1000,
                        deflation_tol::Float64 = 1e-7)::EigvalsLanczosResult =
    with_cxx_csr_matrix(m) do cm
        cxx_eigvals_lanczos_inplace(cm, psi0.cxx_state, neigvals, precision,
                                    max_iterations, deflation_tol)
    end

# --- time evolution -----------------------------------------------------
evolve_lanczos(m::CSRMatrix, psi::State, t::Number; precision::Float64 = 1e-12,
               shift::Float64 = 0.0, normalize::Bool = false,
               max_iterations::Int64 = 1000,
               deflation_tol::Float64 = 1e-7)::EvolveLanczosResult =
    with_cxx_csr_matrix(m) do cm
        cxx_evolve_lanczos(cm, psi.cxx_state, t, precision, shift, normalize,
                           max_iterations, deflation_tol)
    end

evolve_lanczos_inplace(m::CSRMatrix, psi::State, t::Number;
                       precision::Float64 = 1e-12, shift::Float64 = 0.0,
                       normalize::Bool = false, max_iterations::Int64 = 1000,
                       deflation_tol::Float64 = 1e-7)::EvolveLanczosInplaceResult =
    with_cxx_csr_matrix(m) do cm
        cxx_evolve_lanczos_inplace(cm, psi.cxx_state, t, precision, shift,
                                   normalize, max_iterations, deflation_tol)
    end

time_evolve(m::CSRMatrix, psi0::State, time::Float64; precision::Float64 = 1e-12,
            algorithm::String = "lanczos")::State =
    with_cxx_csr_matrix(m) do cm
        State(cxx_time_evolve(cm, psi0.cxx_state, time, precision, algorithm))
    end

time_evolve_inplace(m::CSRMatrix, psi0::State, time::Float64;
                    precision::Float64 = 1e-12, algorithm::String = "lanczos") =
    with_cxx_csr_matrix(m) do cm
        cxx_time_evolve_inplace(cm, psi0.cxx_state, time, precision, algorithm)
    end

imaginary_time_evolve(m::CSRMatrix, psi0::State, time::Float64;
                      precision::Float64 = 1e-12, shift::Float64 = 0.0)::State =
    with_cxx_csr_matrix(m) do cm
        State(cxx_imaginary_time_evolve(cm, psi0.cxx_state, time, precision,
                                        shift))
    end

imaginary_time_evolve_inplace(m::CSRMatrix, psi0::State, time::Float64;
                              precision::Float64 = 1e-12, shift::Float64 = 0.0) =
    with_cxx_csr_matrix(m) do cm
        cxx_imaginary_time_evolve_inplace(cm, psi0.cxx_state, time, precision,
                                          shift)
    end

time_evolve_expokit(m::CSRMatrix, state::State, time::Float64;
                    precision::Float64 = 1e-12, m_krylov::Int64 = 30,
                    anorm::Float64 = 0.0,
                    nnorm::Int64 = 2)::TimeEvolveExpokitResult =
    with_cxx_csr_matrix(m) do cm
        cxx_time_evolve_expokit(cm, state.cxx_state, time, precision, m_krylov,
                                anorm, nnorm)
    end

time_evolve_expokit_inplace(m::CSRMatrix, state::State, time::Float64;
                            precision::Float64 = 1e-12, m_krylov::Int64 = 30,
                            anorm::Float64 = 0.0,
                            nnorm::Int64 = 2)::TimeEvolveExpokitInplaceResult =
    with_cxx_csr_matrix(m) do cm
        cxx_time_evolve_expokit_inplace(cm, state.cxx_state, time, precision,
                                        m_krylov, anorm, nnorm)
    end
