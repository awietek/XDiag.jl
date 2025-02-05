struct Permutation
    cxx_permutation::cxx_Permutation
end

# Constructors
Permutation() = Permutation(cxx_Permutation())
Permutation(size::Int64) = Permutation(cxx_permutation(size))
Permutation(array::Vector{Int64}) = Permutation(cxx_Permutation(StdVector(array .- 1)))

# Methods
inverse(perm::Permutation) = Permutation(inverse(perm.cxx_permutation))
array(perm::Permutation) = Vector{Int64}(array(perm.cxx_permutation)) .+ 1
Base.:*(p1::Permutation, p2::Permutation) =
    Permutation(cxx_multiply(p1.cxx_permutation, p2.cxx_permutation))
Base.:^(p::Permutation, power::Int64) = Permutation(cxx_pow(p.cxx_permutation, power))

# Utils
Base.size(perm::Permutation) = size(perm.cxx_permutation)
Base.:(==)(p1::Permutation, p2::Permutation) = Bool(p1.cxx_permutation == p2.cxx_permutation)

# Output
to_string(perm::Permutation) = String(to_string(perm.cxx_permutation))
Base.show(io::IO, perm::Permutation) = print(io, "\n" * to_string(perm.cxx_permutation))

