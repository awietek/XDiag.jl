function eig0(
    ops::OpSum,
    block::Block;
    precision::Real = 1e-12,
    maxiter::Int64 = 1000,
    force_complex::Bool = false,
    seed::Int64 = 42,
)
    return eig0(ops.cxx_opsum, block.cxx_block, precision, maxiter, force_complex, seed)
end

function eigval0(
    ops::OpSum,
    block::Block;
    precision::Real = 1e-12,
    maxiter::Integer = 1000,
    force_complex::Bool = false,
    seed::Integer = 42,
)
    return eigval0(ops.cxx_opsum, block.cxx_block, precision, maxiter, force_complex, seed)
end
