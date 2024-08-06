struct Permutation
    cxx_perm::cxx_Permutation
end

# Constructors
Permutation(array::Vector{Int64}) = Permutation(cxx_Permutation(StdVector(array)))

# Methods
Base.size(perm::Permutation) = size(perm.array)(0)
inverse(perm::Permutation) = Permutation(inverse(perm.cxx_perm))
Base.:getindex(perm::Permutation, idx::Integer) = perm.array[idx]
Base.:*(p1::Permutation, p2::Permutation) = Permutation(multiply(p1.cxx_perm, p2.cxx_perm))

# Output
Base.show(io::IO, perm::Permutation) = print(io, "\n" * to_string(perm.cxx_perm))

