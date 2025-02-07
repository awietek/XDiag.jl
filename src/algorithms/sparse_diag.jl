function eig0(ops::OpSum, block::Block;	precision::Float64 = 1e-12, 
	      max_iterations::Int64 = 1000, random_seed::Int64 = 42)
    e0, cxx_state = cxx_eig0(ops.cxx_opsum, block.cxx_block, precision,
                             max_iterations, random_seed)
    return Float64(e0), State(cxx_state)
end

function eigval0(ops::OpSum, block::Block; precision::Float64 = 1e-12, 
                 max_iterations::Int64 = 1000, random_seed::Int64 = 42)::Float64
    return cxx_eigval0(ops.cxx_opsum, block.cxx_block, precision,
                       max_iterations, random_seed)
end
