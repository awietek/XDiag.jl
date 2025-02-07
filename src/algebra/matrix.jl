function matrix(ops::OpSum, block_in::Block, block_out::Block)
    if isreal(ops) && isreal(block_in) && isreal(block_out)
        # Allocate matrix on julia side
        mat = Matrix{Float64}(undef, size(block_in), size(block_out))

        # Let the C++ routine write to this matrix
        cxx_matrix(Base.unsafe_convert(Ptr{Float64}, mat), ops.cxx_opsum,
                   block_in.cxx_block, block_out.cxx_block)
       
        return mat
    else
        # Allocate matrix on julia side
        mat = Matrix{ComplexF64}(undef, size(block_in), size(block_out))

        # Let the C++ routine write to this matrix
        cxx_matrixC(Base.unsafe_convert(Ptr{ComplexF64}, mat), ops.cxx_opsum,
                block_in.cxx_block, block_out.cxx_block)
        return mat
    end
end
matrix(op::Op, block_in::Block, block_out::Block) = matrix(OpSum(op), block_in, block_out)

function matrix(ops::OpSum, block::Block)
    blockr = Type{Block}(cxx_block(ops, block))
    return matrix(ops, block, blockr)
end
matrix(op::Op, block::Block) = matrix(OpSum(op), block)
