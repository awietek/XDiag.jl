struct EvolveLanczosResult
    alphas::Vector{Float64}
    betas::Vector{Float64}
    eigenvalues::Vector{Float64}
    niterations::Int64
    criterion::String
    state::State
end
convert(::Type{T}, res::cxx_EvolveLanczosResult) where T <: EvolveLanczosResult =
    EvolveLanczosResult(to_julia(alphas(res)),
                        to_julia(betas(res)),
                        to_julia(eigenvalues(res)),
                        niterations(res),
                        criterion(res),
                        state(res))

evolve_lanczos(H::OpSum, psi::State, t::Float64;
               precision::Float64 = 1e-12,
               shift::Float64=0.0,
               normalize::Bool=false,
               max_iterations::Int64 = 1000,
               deflation_tol::Float64 = 1e-7)::EvolveLanczosResult =
                   cxx_evolve_lanczos(H.cxx_opsum, psi.cxx_state, t,
                                      precision, shift, normalize,
                                      max_iterations, deflation_tol)

evolve_lanczos(H::OpSum, psi::State, z::ComplexF64;
               precision::Float64 = 1e-12,
               shift::Float64=0.0,
               normalize::Bool=false,
               max_iterations::Int64 = 1000,
               deflation_tol::Float64 = 1e-7)::EvolveLanczosResult =
                   cxx_evolve_lanczos(H.cxx_opsum, psi.cxx_state, z,
                                      precision, shift, normalize,
                                      max_iterations, deflation_tol)


struct EvolveLanczosInplaceResult
    alphas::Vector{Float64}
    betas::Vector{Float64}
    eigenvalues::Vector{Float64}
    niterations::Int64
    criterion::String
end
convert(::Type{T}, res::cxx_EvolveLanczosInplaceResult) where T <: EvolveLanczosInplaceResult =
    EvolveLanczosInplaceResult(to_julia(alphas(res)),
                               to_julia(betas(res)),
                               to_julia(eigenvalues(res)),
                               niterations(res),
                               criterion(res))

evolve_lanczos_inplace(H::OpSum, psi::State, t::Float64;
                       precision::Float64 = 1e-12,
                       shift::Float64=0.0,
                       normalize::Bool=false,
                       max_iterations::Int64 = 1000,
                       deflation_tol::Float64 = 1e-7)::EvolveLanczosInplaceResult =
                           cxx_evolve_lanczos_inplace(H.cxx_opsum,
                                                      psi.cxx_state,
                                                      t, precision,
                                                      shift, normalize,
                                                      max_iterations,
                                                      deflation_tol)

evolve_lanczos_inplace(H::OpSum, psi::State, z::ComplexF64;
                       precision::Float64 = 1e-12,
                       shift::Float64=0.0, normalize::Bool=false,
                       max_iterations::Int64 = 1000,
                       deflation_tol::Float64 = 1e-7)::EvolveLanczosInplaceResult =
                           cxx_evolve_lanczos_inplace(H.cxx_opsum,
                                                      psi.cxx_state,
                                                      z, precision,
                                                      shift, normalize,
                                                      max_iterations,
                                                      deflation_tol)

