struct Op
    cxx_op::cxx_Op
end

# Constructors
Op() = Op(cxx_Op())
Op(type::String, cpl::Coupling, sites::Vector{Int64}) =
    Op(cxx_Op(type, cpl.cxx_coupling, StdVector(sites)))
Op(type::String, cpl::Coupling, site::Int64) = Op(cxx_Op(type, cpl.cxx_coupling, site))

Op(type::String, name::String, sites::Vector{Int64}) =
    Op(cxx_Op(type, name, StdVector(sites)))
Op(type::String, name::String, site::Int64) = Op(cxx_Op(type, name, site))

Op(type::String, val::Float64, sites::Vector{Int64}) =
    Op(cxx_Op(type, val, StdVector(sites)))
Op(type::String, val::Float64, site::Int64) = Op(cxx_Op(type, val, site))

Op(type::String, val::ComplexF64, sites::Vector{Int64}) =
    Op(cxx_Op(type, val, StdVector(sites)))
Op(type::String, val::ComplexF64, site::Int64) = Op(cxx_Op(type, val, site))

Op(type::String, mat::Matrix{Float64}, sites::Vector{Int64}) =
    Op(cxx_Op(type, to_armadillo(mat), StdVector(sites)))
Op(type::String, mat::Matrix{Float64}, site::Int64) =
    Op(cxx_Op(type, to_armadillo(mat), site))

Op(type::String, mat::Matrix{Int64}, sites::Vector{Int64}) =
    Op(type, convert(Matrix{Float64}, mat), sites)
Op(type::String, mat::Matrix{Int64}, site::Int64) =
    Op(type, convert(Matrix{Float64}, mat), site)

Op(type::String, mat::Matrix{ComplexF64}, sites::Vector{Int64}) =
    Op(cxx_Op(type, to_armadillo(mat), StdVector(sites)))
Op(type::String, mat::Matrix{ComplexF64}, site::Int64) =
    Op(cxx_Op(type, to_armadillo(mat), site))

Op(type::String, mat::Matrix{Complex{Int64}}, sites::Vector{Int64}) =
    Op(type, convert(Matrix{ComplexF64}, mat), sites)
Op(type::String, mat::Matrix{Complex{Int64}}, site::Int64) =
    Op(type, convert(Matrix{ComplexF64}, mat), site)
       

# methods
type(op::Op) = String(type(op.cxx_op))
coupling(op::Op) = Coupling(coupling(op.cxx_op))
Base.size(op::Op) = Int64(size(op.cxx_op))
Base.getindex(op::Op, idx::Int64) = Int64(getindex(op.cxx_op, idx))
sites(op::Op) = Vector{Int64}(sites(op.cxx_op))
isreal(op::Op) = Bool(isreal(op.cxx_op))
ismatrix(op::Op) = Bool(ismatrix(op.cxx_op))
isexplicit(op::Op) = Bool(isexplicit(op.cxx_op))

# Output
Base.show(io::IO, op::Op) = print(io, "\n" * to_string(op.cxx_op))
