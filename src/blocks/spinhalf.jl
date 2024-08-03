struct Spinhalf <: Block
    cxx_block::cxx_Spinhalf
end

# Constructors
Spinhalf(n_sites::Integer) = Spinhalf(cxx_Spinhalf(n_sites))
Spinhalf(n_sites::Integer, n_up::Integer) = Spinhalf(cxx_Spinhalf(n_sites, n_up))
Spinhalf(n_sites::Integer, group::PermutationGroup, irrep::Representation) =
    Spinhalf(cxx_Spinhalf(n_sites, group.cxx_group, irrep.cxx_representation))
Spinhalf(n_sites::Integer, n_up::Integer, group::PermutationGroup, irrep::Representation) =
    Spinhalf(cxx_Spinhalf(n_sites, n_up, group.cxx_group, irrep.cxx_representation))

# Methods
n_sites(block::Spinhalf) = Int64(n_sites(block.cxx_block))
Base.size(block::Spinhalf) = Int64(size(block.cxx_block))
Base.isreal(block::Spinhalf; precision::Real = 1e-12) = Bool(isreal(block.cxx_block, precision))

# Output
Base.show(io::IO, block::Spinhalf) = print(io, "\n" * to_string(block.cxx_block))
