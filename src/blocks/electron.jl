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
n_up(block::Electron) = n_up(block.cxx_block)
n_dn(block::Electron) = n_dn(block.cxx_block)
permutation_group(block::Electron) = PermutationGroup(permutation_group((block.cxx_block)))
irrep(block::Electron) = Representation(irrep(block.cxx_block))
Base.isreal(block::Electron) = isreal(block.cxx_block)
dim(block::Electron) = dim(block.cxx_block)
Base.size(block::Electron) = size(block.cxx_block)
index(block::Electron, pstate::ProductState) =
    Int64(index(block.cxx_block, pstate.cxx_product_state)) + 1

# Iterators
function Base.iterate(block::Electron)
    if size(block) > 0
        b = _begin(block.cxx_block)
        return ProductState(_deref(b)), b
    else
        return nothing
    end
end

function Base.iterate(block::Electron, state)
    _incr(state)
    if state != _end(block.cxx_block)
        return ProductState(_deref(state)), state
    else
        return nothing
    end
end

# Output
Base.show(io::IO, block::Electron) = print(io, "\n" * to_string(block.cxx_block))
