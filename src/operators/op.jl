using Printf

struct Op
    cxx_op::cxx_Op
end

# Constructors
Op() = Op(cxx_Op())
Op(type::String) = Op(cxx_Op(type))

Op(type::String, site::Int64) = Op(cxx_Op(type, site-1))
Op(type::String, sites::Vector{Int64}) = Op(cxx_Op(type, StdVector(sites .- 1)))

Op(type::String, site::Int64, mat::Matrix{Float64}) =
    Op(cxx_Op(type, site-1, to_armadillo(mat)))
Op(type::String, sites::Vector{Int64}, mat::Matrix{Float64}) =
    Op(cxx_Op(type, StdVector(sites .- 1), to_armadillo(mat)))

Op(type::String, site::Int64, mat::Matrix{ComplexF64}) =
    Op(cxx_Op(type, site-1, to_armadillo(mat)))
Op(type::String, sites::Vector{Int64}, mat::Matrix{ComplexF64}) =
    Op(cxx_Op(type, StdVector(sites .- 1), to_armadillo(mat)))


# methods
type(op::Op) = String(strip(type(op.cxx_op)))
Base.size(op::Op) = Int64(size(op.cxx_op))
Base.getindex(op::Op, idx::Int64) = Int64(getindex(op.cxx_op, idx)) + 1
sites(op::Op) = Vector{Int64}(sites(op.cxx_op)) .+ 1
Base.isreal(op::Op) = Bool(isreal(op.cxx_op))

# Output
function Base.show(io::IO, op::Op)
    print(io, to_string(op.cxx_op))
end
