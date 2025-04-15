# SPDX-FileCopyrightText: 2025 Alexander Wietek <awietek@pks.mpg.de>
#
# SPDX-License-Identifier: Apache-2.0

struct Representation
    cxx_representation::cxx_Representation
end
convert(::Type{T}, r::cxx_Representation) where T <: Representation =
    Representation(r)

# Constructors
Representation(group::PermutationGroup) = Representation(cxx_Representation(group.cxx_group))
Representation(group::PermutationGroup, characters::Vector{Float64}) =
    Representation(cxx_Representation(group.cxx_group, to_armadillo(characters)))
Representation(group::PermutationGroup, characters::Vector{ComplexF64}) =
    Representation(cxx_Representation(group.cxx_group, to_armadillo(characters)))

# Methods
Base.size(irrep::Representation)::Int64 = size(irrep.cxx_representation)
Base.isreal(irrep::Representation)::Bool = isreal(irrep.cxx_representation)
Base.:*(r1::Representation, r2::Representation)::Representation =
    multiply(r1.cxx_representation, r2.cxx_representation)
Base.:(==)(r1::Representation, r2::Representation)::Bool =
    r1.cxx_representation == r2.cxx_representation

# Output
to_string(irrep::Representation)::String = to_string(irrep.cxx_representation)
Base.show(io::IO, irrep::Representation) = print(io, "\n" * to_string(irrep.cxx_representation))
