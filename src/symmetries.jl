struct Permutation
    array::Vector{Int64}
    cxx_perm::cxx_Permutation
end

Permutation(array::Vector{Int64}) = Permutation(array, cxx_Permutation(StdVector(array)))
Permutation(cxx_perm::cxx_Permutation) = Permutation(array(cxx_perm), cxx_perm)

function Base.:getindex(perm::Permutation, idx::Integer)
    return perm.array[idx] 
end

function size(perm::Permutation)
    return size(perm.array)(0)
end

function inverse(perm::Permutation)
    cxx_perm_inv = inverse(perm.cxx_perm)
    return Permutation(cxx_perm_inv)
end

function Base.:*(p1::Permutation, p2::Permutation)
    return Permutation(multiply(p1.cxx_perm, p2.cxx_perm))
end

function Base.show(io::IO, perm::Permutation)
    print_pretty("xdiag::Permutation", perm.cxx_perm)
end

