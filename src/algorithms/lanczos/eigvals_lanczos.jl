# SPDX-FileCopyrightText: 2025 Alexander Wietek <awietek@pks.mpg.de>
#
# SPDX-License-Identifier: Apache-2.0

struct EigvalsLanczosResult
    alphas::Vector{Float64}
    betas::Vector{Float64}
    eigenvalues::Vector{Float64}
    niterations::Int64
    criterion::String
end
convert(::Type{T}, res::cxx_EigvalsLanczosResult) where T <: EigvalsLanczosResult =
    EigvalsLanczosResult(to_julia(alphas(res)),
                         to_julia(betas(res)),
                         to_julia(eigenvalues(res)),
                         niterations(res),
                         criterion(res))

eigvals_lanczos(ops::OpSum, block::Block; neigvals::Int64 = 1, 
		precision::Float64 = 1e-12,
                max_iterations::Int64 = 1000,
                deflation_tol::Float64 = 1e-7,
                random_seed::Int64 = 42)::EigvalsLanczosResult = 
    cxx_eigvals_lanczos(ops.cxx_opsum, block.cxx_block, neigvals, precision,
                               max_iterations, deflation_tol, random_seed)


eigvals_lanczos(ops::OpSum, psi0::State; neigvals::Int64 = 1, 
		precision::Float64 = 1e-12,
                max_iterations::Int64 = 1000,
                deflation_tol::Float64 = 1e-7)::EigvalsLanczosResult =
    cxx_eigvals_lanczos(ops.cxx_opsum, psi0.cxx_state, neigvals, precision,
                        max_iterations, deflation_tol)


eigvals_lanczos_inplace(ops::OpSum, psi0::State; neigvals::Int64 = 1, 
		        precision::Float64 = 1e-12,
                        max_iterations::Int64 = 1000,
                        deflation_tol::Float64 = 1e-7)::EigvalsLanczosResult =
                            cxx_eigvals_lanczos_inplace(ops.cxx_opsum,
                                                        psi0.cxx_state,
                                                        neigvals,
                                                        precision,
                                                        max_iterations,
                                                        deflation_tol)

