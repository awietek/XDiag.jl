struct tJ <: Block
    cxx_block::cxx_tJ
end

# Constructors
tJ(n_sites::Integer, n_up::Integer, n_dn::Integer) = tJ(cxx_tJ(n_sites, n_up, n_dn))
tJ(
    n_sites::Integer,
    n_up::Integer,
    n_dn::Integer,
    group::PermutationGroup,
    irrep::Representation,
) = tJ(cxx_tJ(n_sites, n_up, n_dn, group.cxx_group, irrep.cxx_representation))

# Methods
n_sites(block::tJ) = n_sites(block.cxx_block)
Base.size(block::tJ) = size(block.cxx_block)
Base.isreal(block::tJ; precision::Real = 1e-12) = isreal(block.cxx_block, precision)

# Output
Base.show(io::IO, block::tJ) = print(io, "\n" * to_string(block.cxx_block))
