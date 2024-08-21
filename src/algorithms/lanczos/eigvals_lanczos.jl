struct EigvalsLanczosResult
    alphas::Vector{Float64}
    betas::Vector{Float64}
    eigenvalues::Vector{Float64}
    niterations::Int64
    criterion::String
end

function eigvals_lanczos(
    ops::OpSum,
    block::Block;
    neigvals::Int64 = 1,
    precision::Float64 = 1e-12,
    max_iterations::Int64 = 1000,
    force_complex::Bool = false,
    deflation_tol::Float64 = 1e-7,
    random_seed::Int64 = 42,
)
    cxx_res = cxx_eigvals_lanczos(
        ops.cxx_opsum,
        block.cxx_block,
        neigvals,
        precision,
        max_iterations,
        force_complex,
        deflation_tol,
        random_seed,
    )
    return EigvalsLanczosResult(
        to_julia(alphas(cxx_res)),
        to_julia(betas(cxx_res)),
        to_julia(eigenvalues(cxx_res)),
        niterations(cxx_res),
        criterion(cxx_res),
    )
end

