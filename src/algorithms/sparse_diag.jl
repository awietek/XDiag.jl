# SPDX-FileCopyrightText: 2025 Alexander Wietek <awietek@pks.mpg.de>
#
# SPDX-License-Identifier: Apache-2.0

function eig0(ops::OpSum, block::Block;	precision::Float64 = 1e-12, 
	      max_iterations::Int64 = 1000, random_seed::Int64 = 42)
    e0, cxx_state = cxx_eig0(ops.cxx_opsum, block.cxx_block, precision,
                             max_iterations, random_seed)
    return Float64(e0), State(cxx_state)
end

function eig0(ops::CSRMatrix, block::Block; precision::Float64 = 1e-12, 
	      max_iterations::Int64 = 1000, random_seed::Int64 = 42)
    e0, cxx_state = with_cxx_csr_matrix(ops) do cxx_ops
        cxx_eig0(cxx_ops, block.cxx_block, precision,
                 max_iterations, random_seed)
    end
    return Float64(e0), State(cxx_state)
end


function eigval0(ops::OpSum, block::Block; precision::Float64 = 1e-12, 
                 max_iterations::Int64 = 1000, random_seed::Int64 = 42)::Float64
    return cxx_eigval0(ops.cxx_opsum, block.cxx_block, precision,
                       max_iterations, random_seed)
end

function eigval0(ops::CSRMatrix, block::Block; precision::Float64 = 1e-12, 
                 max_iterations::Int64 = 1000, random_seed::Int64 = 42)::Float64
    with_cxx_csr_matrix(ops) do cxx_ops
        return cxx_eigval0(cxx_ops, block.cxx_block, precision,
                           max_iterations, random_seed)
    end
end
