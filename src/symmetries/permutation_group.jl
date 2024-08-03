struct PermutationGroup
    permutations::Vector{Permutation}
    cxx_group::cxx_PermutationGroup
end

# Constructors
function PermutationGroup(permutations::Vector{Permutation})
    cxx_perms = cxx_Permutation[]
    for p in permutations
        push!(cxx_perms, p.cxx_perm)
    end
    PermutationGroup(permutations, cxx_PermutationGroup(StdVector(cxx_perms)))
end

# Methods
Base.size(group::PermutationGroup) = size(group.cxx_group)
n_sites(group::PermutationGroup) = n_sites(group.cxx_group)
inverse(group::PermutationGroup, idx::Integer) = inverse(group.cxx_group, idx)

# Output
Base.show(io::IO, group::PermutationGroup) = print(io, "\n" * to_string(group.cxx_group))

