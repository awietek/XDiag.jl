struct Permutation
    cxx_perm::cxx_Permutation
end

# Constructors
Permutation(array::Vector{Int64}) = Permutation(cxx_Permutation(StdVector(array .- 1)))

# Methods
Base.size(perm::Permutation) = size(array(perm.cxx_perm))
inverse(perm::Permutation) = Permutation(inverse(perm.cxx_perm))
Base.:getindex(perm::Permutation, idx::Integer) = array(perm.cxx_perm)[idx]
Base.:*(p1::Permutation, p2::Permutation) = Permutation(multiply(p1.cxx_perm, p2.cxx_perm))

# Output
function Base.show(io::IO, perm::Permutation)
    # print(io, "\n" * to_string(perm.cxx_perm))
    print(io, array(perm.cxx_perm) .+ 1)
end

