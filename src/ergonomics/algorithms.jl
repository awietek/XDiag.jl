# SPDX-License-Identifier: Apache-2.0
# Hand-written ergonomic layer: diagonalization + time evolution.
#
# The algorithms take keyword arguments and return materialised Julia result
# structs (real fields, filled eagerly via convert from the cxx_ result). The
# cxx_ result structs are add_type'd and their field accessors registered by the
# generated C++ side; the cxx_<algorithm> free functions are the cxx_-prefixed
# registrations. (CSRMatrix-input overloads are provided in ergonomics/sparse.jl.)

# ------------------------------------------------------------------ sparse_diag
function eig0(ops::OpSum, block::Block; precision::Float64 = 1e-12,
              max_iterations::Int64 = 1000, random_seed::Int64 = 42)
    e0, psi = cxx_eig0(ops.cxx_opsum, block.cxx_block, precision,
                       max_iterations, random_seed)
    return Float64(e0), State(psi)
end

eigval0(ops::OpSum, block::Block; precision::Float64 = 1e-12,
        max_iterations::Int64 = 1000, random_seed::Int64 = 42)::Float64 =
    cxx_eigval0(ops.cxx_opsum, block.cxx_block, precision, max_iterations,
                random_seed)

function eigs(ops::OpSum, block::Block; neigs::Int64 = 1,
              precision::Float64 = 1e-12, max_iterations::Int64 = 1000,
              random_seed::Int64 = 42)
    es, psis = cxx_eigs(ops.cxx_opsum, block.cxx_block, neigs, precision,
                        max_iterations, random_seed)
    return to_julia(es), State(psis)
end

# ----------------------------------------------------------------- eigs_lanczos
struct EigsLanczosResult
    alphas::Vector{Float64}
    betas::Vector{Float64}
    eigenvalues::Vector{Float64}
    eigenvectors::State
    niterations::Int64
    criterion::String
end
convert(::Type{T}, r::cxx_EigsLanczosResult) where {T<:EigsLanczosResult} =
    EigsLanczosResult(to_julia(alphas(r)), to_julia(betas(r)),
                      to_julia(eigenvalues(r)), State(eigenvectors(r)),
                      niterations(r), criterion(r))

eigs_lanczos(ops::OpSum, block::Block; neigvals::Int64 = 1,
             precision::Float64 = 1e-12, max_iterations::Int64 = 1000,
             deflation_tol::Float64 = 1e-7,
             random_seed::Int64 = 42)::EigsLanczosResult =
    cxx_eigs_lanczos(ops.cxx_opsum, block.cxx_block, neigvals, precision,
                     max_iterations, deflation_tol, random_seed)

eigs_lanczos(ops::OpSum, psi0::State; neigvals::Int64 = 1,
             precision::Float64 = 1e-12, max_iterations::Int64 = 1000,
             deflation_tol::Float64 = 1e-7)::EigsLanczosResult =
    cxx_eigs_lanczos(ops.cxx_opsum, psi0.cxx_state, neigvals, precision,
                     max_iterations, deflation_tol)

# --------------------------------------------------------------- eigvals_lanczos
struct EigvalsLanczosResult
    alphas::Vector{Float64}
    betas::Vector{Float64}
    eigenvalues::Vector{Float64}
    niterations::Int64
    criterion::String
end
convert(::Type{T}, r::cxx_EigvalsLanczosResult) where {T<:EigvalsLanczosResult} =
    EigvalsLanczosResult(to_julia(alphas(r)), to_julia(betas(r)),
                         to_julia(eigenvalues(r)), niterations(r), criterion(r))

eigvals_lanczos(ops::OpSum, block::Block; neigvals::Int64 = 1,
                precision::Float64 = 1e-12, max_iterations::Int64 = 1000,
                deflation_tol::Float64 = 1e-7,
                random_seed::Int64 = 42)::EigvalsLanczosResult =
    cxx_eigvals_lanczos(ops.cxx_opsum, block.cxx_block, neigvals, precision,
                        max_iterations, deflation_tol, random_seed)

eigvals_lanczos(ops::OpSum, psi0::State; neigvals::Int64 = 1,
                precision::Float64 = 1e-12, max_iterations::Int64 = 1000,
                deflation_tol::Float64 = 1e-7)::EigvalsLanczosResult =
    cxx_eigvals_lanczos(ops.cxx_opsum, psi0.cxx_state, neigvals, precision,
                        max_iterations, deflation_tol)

eigvals_lanczos_inplace(ops::OpSum, psi0::State; neigvals::Int64 = 1,
                        precision::Float64 = 1e-12,
                        max_iterations::Int64 = 1000,
                        deflation_tol::Float64 = 1e-7)::EigvalsLanczosResult =
    cxx_eigvals_lanczos_inplace(ops.cxx_opsum, psi0.cxx_state, neigvals,
                                precision, max_iterations, deflation_tol)

# ---------------------------------------------------------------- evolve_lanczos
struct EvolveLanczosResult
    alphas::Vector{Float64}
    betas::Vector{Float64}
    eigenvalues::Vector{Float64}
    niterations::Int64
    criterion::String
    state::State
end
convert(::Type{T}, r::cxx_EvolveLanczosResult) where {T<:EvolveLanczosResult} =
    EvolveLanczosResult(to_julia(alphas(r)), to_julia(betas(r)),
                        to_julia(eigenvalues(r)), niterations(r), criterion(r),
                        State(state(r)))

evolve_lanczos(H::OpSum, psi::State, t::Number; precision::Float64 = 1e-12,
               shift::Float64 = 0.0, normalize::Bool = false,
               max_iterations::Int64 = 1000,
               deflation_tol::Float64 = 1e-7)::EvolveLanczosResult =
    cxx_evolve_lanczos(H.cxx_opsum, psi.cxx_state, t, precision, shift,
                       normalize, max_iterations, deflation_tol)

struct EvolveLanczosInplaceResult
    alphas::Vector{Float64}
    betas::Vector{Float64}
    eigenvalues::Vector{Float64}
    niterations::Int64
    criterion::String
end
convert(::Type{T}, r::cxx_EvolveLanczosInplaceResult) where {T<:EvolveLanczosInplaceResult} =
    EvolveLanczosInplaceResult(to_julia(alphas(r)), to_julia(betas(r)),
                               to_julia(eigenvalues(r)), niterations(r),
                               criterion(r))

evolve_lanczos_inplace(H::OpSum, psi::State, t::Number; precision::Float64 = 1e-12,
                       shift::Float64 = 0.0, normalize::Bool = false,
                       max_iterations::Int64 = 1000,
                       deflation_tol::Float64 = 1e-7)::EvolveLanczosInplaceResult =
    cxx_evolve_lanczos_inplace(H.cxx_opsum, psi.cxx_state, t, precision, shift,
                               normalize, max_iterations, deflation_tol)

# -------------------------------------------------------------------- time_evolve
time_evolve(ops::OpSum, psi0::State, time::Float64; precision::Float64 = 1e-12,
            algorithm::String = "lanczos")::State =
    State(cxx_time_evolve(ops.cxx_opsum, psi0.cxx_state, time, precision,
                          algorithm))

time_evolve_inplace(ops::OpSum, psi0::State, time::Float64;
                    precision::Float64 = 1e-12, algorithm::String = "lanczos") =
    cxx_time_evolve_inplace(ops.cxx_opsum, psi0.cxx_state, time, precision,
                            algorithm)

# ---------------------------------------------------------- imaginary_time_evolve
imaginary_time_evolve(ops::OpSum, psi0::State, time::Float64;
                      precision::Float64 = 1e-12, shift::Float64 = 0.0)::State =
    State(cxx_imaginary_time_evolve(ops.cxx_opsum, psi0.cxx_state, time,
                                    precision, shift))

imaginary_time_evolve_inplace(ops::OpSum, psi0::State, time::Float64;
                              precision::Float64 = 1e-12,
                              shift::Float64 = 0.0) =
    cxx_imaginary_time_evolve_inplace(ops.cxx_opsum, psi0.cxx_state, time,
                                      precision, shift)

# ------------------------------------------------------------ time_evolve_expokit
struct TimeEvolveExpokitResult
    error::Float64
    hump::Float64
    state::State
end
convert(::Type{T}, r::cxx_TimeEvolveExpokitResult) where {T<:TimeEvolveExpokitResult} =
    TimeEvolveExpokitResult(error(r), hump(r), State(state(r)))

time_evolve_expokit(ops::OpSum, state::State, time::Float64;
                    precision::Float64 = 1e-12, m::Int64 = 30,
                    anorm::Float64 = 0.0,
                    nnorm::Int64 = 2)::TimeEvolveExpokitResult =
    cxx_time_evolve_expokit(ops.cxx_opsum, state.cxx_state, time, precision, m,
                            anorm, nnorm)

struct TimeEvolveExpokitInplaceResult
    error::Float64
    hump::Float64
end
convert(::Type{T}, r::cxx_TimeEvolveExpokitInplaceResult) where {T<:TimeEvolveExpokitInplaceResult} =
    TimeEvolveExpokitInplaceResult(error(r), hump(r))

time_evolve_expokit_inplace(ops::OpSum, state::State, time::Float64;
                            precision::Float64 = 1e-12, m::Int64 = 30,
                            anorm::Float64 = 0.0,
                            nnorm::Int64 = 2)::TimeEvolveExpokitInplaceResult =
    cxx_time_evolve_expokit_inplace(ops.cxx_opsum, state.cxx_state, time,
                                    precision, m, anorm, nnorm)
