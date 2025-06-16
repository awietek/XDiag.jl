# SPDX-FileCopyrightText: 2025 Alexander Wietek <awietek@pks.mpg.de>
#
# SPDX-License-Identifier: Apache-2.0

struct Op
    cxx_op::cxx_Op
end
convert(::Type{T}, o::cxx_Op) where T <: Op = Op(o)

# Constructors
Op() = Op(construct_Op())
Op(type::String) = Op(construct_Op(type))

Op(type::String, site::Int64) = Op(construct_Op(type, site-1))
Op(type::String, sites::Vector{Int64}) = Op(construct_Op(type, StdVector(sites .- 1)))

Op(type::String, site::Int64, mat::Matrix{Float64}) =
    Op(construct_Op(type, site-1, to_armadillo(mat)))
Op(type::String, sites::Vector{Int64}, mat::Matrix{Float64}) =
    Op(construct_Op(type, StdVector(sites .- 1), to_armadillo(mat)))

Op(type::String, site::Int64, mat::Matrix{ComplexF64}) =
    Op(construct_Op(type, site-1, to_armadillo(mat)))
Op(type::String, sites::Vector{Int64}, mat::Matrix{ComplexF64}) =
    Op(construct_Op(type, StdVector(sites .- 1), to_armadillo(mat)))

# Methods
type(op::Op)::String = strip(type(op.cxx_op))
Base.size(op::Op)::Int64 = size(op.cxx_op)
Base.getindex(op::Op, idx::Int64)::Int64 = getindex(op.cxx_op, idx) + 1
sites(op::Op)::Vector{Int64} = Vector{Int64}(sites(op.cxx_op)) .+ 1

# Utils
Base.isreal(op::Op)::Bool = isreal(op.cxx_op)
Base.isapprox(op1::Op, op2::Op, rtol::Float64=1e-12, atol::Float64=1e-12)::Bool = isapprox(op1.cxx_op, op2.cxx_op, rtol, atol)
Base.:(==)(op1::Op, op2::Op)::Bool = Bool(op1.cxx_op == op2.cxx_op)

# Output
to_string(op::Op)::String = to_string(ops.cxx_op)
Base.show(io::IO, op::Op) = print(io, to_string(op.cxx_op))

