struct OpSum
    cxx_opsum::cxx_OpSum
end

# Constructors
OpSum() = OpSum(cxx_OpSum())
OpSum(ops::Vector{Op}) = OpSum(cxx_OpSum(StdVector([op.cxx_op for op in ops])))

# Methods
Base.size(ops::OpSum) = Int64(size(ops.cxx_opsum))
defined(ops::OpSum, name::String) = Bool(defined(ops.cxx_opsum, name))
Base.getindex(ops::OpSum, name::String) = Coupling(getindex(ops.cxx_opsum, name))
Base.setindex!(ops::OpSum, cpl, name::String) = setindex!(ops.cxx_opsum, Coupling(cpl).cxx_coupling, name)
couplings(ops::OpSum) = Vector{String}(couplings(ops.cxx_opsum))
isreal(ops::OpSum) = Bool(isreal(ops.cxx_opsum))
isexplicit(ops::OpSum) = Bool(isexplicit(ops.cxx_opsum))

Base.:+(ops::OpSum, ops2::OpSum) = OpSum(ops.cxx_opsum + ops2.cxx_opsum)
Base.:+(ops::OpSum, op2::Op) = OpSum(ops.cxx_opsum + op2.cxx_op)

# Output
Base.show(io::IO, ops::OpSum) = print(io, "\n" * to_string(ops.cxx_opsum))
