struct EigsLanczosResult
    alphas::Vector{Float64}
    betas::Vector{Float64}
    eigenvalues::Vector{Float64}
    eigenvectors::State
    niterations::Int64
    criterion::String
end
convert(EigsLanczosResult, res::cxx_EigsLanczosResult) =
    EigsLanczosResult(to_julia(alphas(res)),
                      to_julia(betas(res)),
                      to_julia(eigenvalues(res)),
                      eigenvectors(res),
                      niterations(res),
                      criterion(res))

eigs_lanczos(ops::OpSum, block::Block; neigvals::Int64 = 1,
             precision::Float64 = 1e-12, max_iterations::Int64 = 1000,
             deflation_tol::Float64 = 1e-7,
             random_seed::Int64 = 42)::EigsLanczosResult =
   cxx_eigs_lanczos(ops.cxx_opsum, block.cxx_block, neigvals, precision,
                    max_iterations, deflation_tol, random_seed)
    

eigs_lanczos(ops::OpSum, state0::State; neigvals::Int64 = 1,
             precision::Float64 = 1e-12, max_iterations::Int64 = 1000,
             deflation_tol::Float64 = 1e-7)::EigsLanczosResult =
   cxx_eigs_lanczos(ops.cxx_opsum, state0.cxx_state, neigvals, precision,
                    max_iterations, deflation_tol)
    
