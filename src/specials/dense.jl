# SPDX-License-Identifier: Apache-2.0
# Hand-written special: dense matrix via the caller-allocated pointer fill.

function matrix(ops::OpSum, block_in::Block, block_out::Block)
    nrows, ncols = size(block_out), size(block_in)
    if isreal(ops) && isreal(block_in) && isreal(block_out)
        m = Matrix{Float64}(undef, nrows, ncols)
        GC.@preserve m cxx_matrix_fill(ops.cxx_opsum, block_in.cxx_block,
                                       block_out.cxx_block, pointer(m))
        return m
    else
        m = Matrix{ComplexF64}(undef, nrows, ncols)
        GC.@preserve m cxx_matrixC_fill(ops.cxx_opsum, block_in.cxx_block,
                                        block_out.cxx_block, pointer(m))
        return m
    end
end
matrix(ops::OpSum, block::B) where {B<:Block} =
    matrix(ops, block, B(cxx_block(ops.cxx_opsum, block.cxx_block)))
matrix(op::Op, block_in::Block, block_out::Block) =
    matrix(OpSum(op), block_in, block_out)
matrix(op::Op, block::Block) = matrix(OpSum(op), block)
