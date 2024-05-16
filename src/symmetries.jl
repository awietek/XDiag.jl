#######################################
# Permutation
struct Permutation
    array::Vector{Int64}
    cxx_perm::cxx_Permutation
end

Permutation(array::Vector{Int64}) = Permutation(array, cxx_Permutation(StdVector(array)))
Permutation(cxx_perm::cxx_Permutation) = Permutation(array(cxx_perm), cxx_perm)

function Base.show(io::IO, perm::Permutation)
    print_pretty("xdiag::Permutation", perm.cxx_perm)
end

function Base.:getindex(perm::Permutation, idx::Integer)
    return perm.array[idx] 
end

function Base.size(perm::Permutation)
    return size(perm.array)(0)
end

function inverse(perm::Permutation)
    cxx_perm_inv = inverse(perm.cxx_perm)
    return Permutation(cxx_perm_inv)
end

function Base.:*(p1::Permutation, p2::Permutation)
    return Permutation(multiply(p1.cxx_perm, p2.cxx_perm))
end

#######################################
# PermutationGroup
struct PermutationGroup
    permutations::Vector{Permutation}
    cxx_group::cxx_PermutationGroup
end

function PermutationGroup(permutations::Vector{Permutation})
    cxx_perms = cxx_Permutation[]
    for p in permutations
        push!(cxx_perms, p.cxx_perm)
    end
    PermutationGroup(permutations, cxx_PermutationGroup(StdVector(cxx_perms)))
end

function Base.show(io::IO, group::PermutationGroup)
    print_pretty("xdiag::PermutationGroup", group.cxx_group)
end

function Base.size(group::PermutationGroup)
    return size(group.cxx_group)
end

function n_sites(group::PermutationGroup)
    return n_sites(group.cxx_group)
end

function inverse(group::PermutationGroup, idx::Integer)
    return inverse(group.cxx_group, idx)
end

#######################################
# Representation
struct Representation
    cxx_representation::cxx_Representation
end

function Representation(characters::Vector{<:Number})
    characters_cplx = Vector{ComplexF64}(characters)
    return Representation(cxx_Representation(StdVector(characters_cplx)))
end

function Base.size(irrep::Representation)
    return size(irrep.cxx_representation)
end

function Base.isreal(irrep::Representation; precision::Float64=1e-12)
    return isreal(irrep.cxx_representation, precision)
end

function Base.show(io::IO, irrep::Representation)
    print_pretty("xdiag::Representation", irrep.cxx_representation)
end

function Base.:*(r1::Representation, r2::Representation)
    return Representation(multiply(r1.cxx_representation, r2.cxx_representation))
end
