struct OpSum
    cxx_opsum::cxx_OpSum
end
convert(::Type{T}, os::cxx_OpSum) where T <: OpSum = OpSum(os)

# Constructors
OpSum() = OpSum(cxx_OpSum())
OpSum(op::Op) = OpSum(cxx_OpSum(op.cxx_op))
OpSum(coupling::Float64, op::Op) = OpSum(cxx_OpSum(coupling, op.cxx_op))
OpSum(coupling::ComplexF64, op::Op) = OpSum(cxx_OpSum(coupling, op.cxx_op))
OpSum(coupling::String, op::Op) = OpSum(cxx_OpSum(coupling, op.cxx_op))

# Methods
plain(ops::OpSum)::OpSum = plain(ops.cxx_opsum)

# * Creation
Base.:*(coupling::Float64, op::Op)::OpSum = cxx_OpSum(coupling, op.cxx_op)
Base.:*(coupling::ComplexF64, op::Op)::OpSum = cxx_OpSum(coupling, op.cxx_op)
Base.:*(coupling::String, op::Op)::OpSum = cxx_OpSum(coupling, op.cxx_op)

# + addition / - subtraction
Base.:+(ops1::OpSum, ops2::OpSum)::OpSum = ops1.cxx_opsum + ops2.cxx_opsum
Base.:+(ops::OpSum, op::Op)::OpSum = ops.cxx_opsum + op.cxx_op
Base.:+(op::Op, ops::OpSum)::OpSum = ops + op
Base.:-(ops1::OpSum, ops2::OpSum)::OpSum = ops1.cxx_opsum - ops2.cxx_opsum
Base.:-(ops::OpSum, op::Op)::OpSum = ops.cxx_opsum - op.cxx_op

# scalar multiplication / division
Base.:*(coupling::Float64, ops::OpSum)::OpSum = coupling * ops.cxx_opsum
Base.:*(coupling::ComplexF64, ops::OpSum)::OpSum = coupling * ops.cxx_opsum
Base.:*(ops::OpSum, coupling::Float64)::OpSum = coupling * ops.cxx_opsum
Base.:*(ops::OpSum, coupling::ComplexF64)::OpSum = coupling * ops.cxx_opsum
Base.:/(ops::OpSum, coupling::Float64)::OpSum = ops.cxx_opsum / coupling
Base.:/(ops::OpSum, coupling::ComplexF64)::OpSum = ops.cxx_opsum / coupling

# setting coupling constants
Base.setindex!(ops::OpSum, cpl::Float64, name::String) = setindex!(ops.cxx_opsum, name, cpl)
Base.setindex!(ops::OpSum, cpl::ComplexF64, name::String) = setindex!(ops.cxx_opsum, name, cpl)

# return defined constants
constants(ops::OpSum)::Vector{String} = Vector{String}(constants(ops.cxx_opsum))

# Utils
Base.isreal(ops::OpSum)::Bool = isreal(ops.cxx_opsum)
Base.isapprox(ops1::OpSum, ops2::OpSum, rtol::Float64=1e-12, atol::Float64=1e-12)::Bool =
    isapprox(ops1.cxx_opsum, ops2.cxx_opsum, rtol, atol)
Base.:(==)(ops1::OpSum, ops2::OpSum)::Bool = ops1.cxx_opsum == ops2.cxx_opsum

# Output
to_string(ops::OpSum) = String(to_string(ops.cxx_opsum))
Base.show(io::IO, ops::OpSum) = print(io, "\n" * to_string(ops.cxx_opsum))
