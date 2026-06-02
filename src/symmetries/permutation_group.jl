# SPDX-FileCopyrightText: 2025 Alexander Wietek <awietek@pks.mpg.de>
#
# SPDX-License-Identifier: Apache-2.0

struct PermutationGroup
    cxx_group::cxx_PermutationGroup
end
convert(::Type{T}, g::cxx_PermutationGroup) where T <: PermutationGroup =
    PermutationGroup(g)

# Constructors
PermutationGroup() = PermutationGroup(construct_PermutationGroup())
function PermutationGroup(matrix::Matrix{Int64})
    matrix0 = matrix .- 1
    m, n = size(matrix0)
    GC.@preserve matrix0 begin
        return PermutationGroup(construct_PermutationGroup(pointer(matrix0), m, n))
    end
end

function PermutationGroup(perms::Vector{Permutation})
    if isempty(perms)
        return PermutationGroup()
    else
        nsites = size(perms[1])
        nperms = size(perms)[1]
        mat = zeros(Int64, (nperms, nsites))
        for (i, perm) in enumerate(perms)
            mat[i, :] = array(perm)
        end
        return PermutationGroup(mat)
    end
end

# Methods
Base.size(group::PermutationGroup)::Int64 = size(group.cxx_group)
nsites(group::PermutationGroup)::Int64 = nsites(group.cxx_group)

# Output
to_string(group::PermutationGroup)::String = to_string(group.cxx_group)
Base.show(io::IO, group::PermutationGroup) = print(io, "\n" * to_string(group.cxx_group))
