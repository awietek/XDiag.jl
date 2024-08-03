struct Electron <: Block
    cxx_block::cxx_Electron
end

# Constructors
Electron(n_sites::Integer) = Electron(cxx_Electron(n_sites))
Electron(n_sites::Integer, n_up::Integer, n_dn::Integer) =
    Electron(cxx_Electron(n_sites, n_up, n_dn))
Electron(n_sites::Integer, group::PermutationGroup, irrep::Representation) =
    Electron(cxx_Electron(n_sites, group.cxx_group, irrep.cxx_representation))
Electron(
    n_sites::Integer,
    n_up::Integer,
    n_dn::Integer,
    group::PermutationGroup,
    irrep::Representation,
) = Electron(cxx_Electron(n_sites, n_up, n_dn, group.cxx_group, irrep.cxx_representation))

# Methods
n_sites(block::Electron) = n_sites(block.cxx_block)
Base.size(block::Electron) = size(block.cxx_block)
Base.isreal(block::Electron; precision::Real = 1e-12) = isreal(block.cxx_block, precision)

# Output
Base.show(io::IO, block::Electron) = print(io, "\n" * to_string(block.cxx_block))
