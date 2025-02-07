function eigvals_lanczos(ops::OpSum, block::Block; neigvals::Int64 = 1, 
		         precision::Float64 = 1e-12, max_iterations::Int64 = 1000,
                         deflation_tol::Float64 = 1e-7, random_seed::Int64 = 42)
    return cxx_eigvals_lanczos(ops.cxx_opsum, block.cxx_block, neigvals, precision,
                               max_iterations, deflation_tol, random_seed)
end

function eigvals_lanczos(ops::OpSum, psi0::State; neigvals::Int64 = 1, 
		         precision::Float64 = 1e-12, max_iterations::Int64 = 1000,
                         deflation_tol::Float64 = 1e-7)
    return cxx_eigvals_lanczos(ops.cxx_opsum, psi0.cxx_state, neigvals, precision,
                               max_iterations, deflation_tol, random_seed)
end

function eigvals_lanczos_inplace(ops::OpSum, psi0::State; neigvals::Int64 = 1, 
		                 precision::Float64 = 1e-12, max_iterations::Int64 = 1000,
                                 deflation_tol::Float64 = 1e-7)
    return cxx_eigvals_lanczos_inplace(ops.cxx_opsum, psi0.cxx_state, neigvals, precision,
                                       max_iterations, deflation_tol, random_seed)
end
