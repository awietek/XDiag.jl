function matrix(
    ops::OpSum,
    block_in::Block,
    block_out::Block;
    force_complex::Bool = false,
    precision::Float64 = 1e-12,
)
    if isreal(ops) && isreal(block_in) && isreal(block_out) && !force_complex
        # Allocate matrix on julia side
        mat = Matrix{Float64}(undef, size(block_in), size(block_out))

        # Let the C++ routine write to this matrix
        matrix(
            Base.unsafe_convert(Ptr{Float64}, mat),
            ops.cxx_opsum,
            block_in.cxx_block,
            block_out.cxx_block,
            precision,
        )
        return mat
    else
        # Allocate matrix on julia side
        mat = Matrix{ComplexF64}(undef, size(block_in), size(block_out))

        # Let the C++ routine write to this matrix
        matrix(
            Base.unsafe_convert(Ptr{ComplexF64}, mat),
            ops.cxx_opsum,
            block_in.cxx_block,
            block_out.cxx_block,
            precision,
        )
        return mat
    end
end

function matrix(
    op::Op,
    block_in::Block,
    block_out::Block;
    force_complex::Bool = false,
    precision::Float64 = 1e-12,
)
    ops = OpSum([op])
    matrix(ops, block_in, block_out; force_complex = force_complex, precision = precision)
end

function matrix(
    ops::OpSum,
    block::Block;
    force_complex::Bool = false,
    precision::Float64 = 1e-12,
)
    return matrix(ops, block, block; force_complex = force_complex, precision = precision)
end

function matrix(
    op::Op,
    block::Block;
    force_complex::Bool = false,
    precision::Float64 = 1e-12,
)
    return matrix(op, block, block; force_complex = force_complex, precision = precision)
end
