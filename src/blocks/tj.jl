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
n_up(block::tJ) = n_up(block.cxx_block)
n_dn(block::tJ) = n_dn(block.cxx_block)
permutation_group(block::tJ) = PermutationGroup(permutation_group((block.cxx_block)))
irrep(block::tJ) = Representation(irrep(block.cxx_block))
Base.isreal(block::tJ) = isreal(block.cxx_block)
dim(block::tJ) = dim(block.cxx_block)
Base.size(block::tJ) = size(block.cxx_block)
index(block::tJ, pstate::ProductState) =
    Int64(index(block.cxx_block, pstate.cxx_product_state)) + 1

# Iterators
function Base.iterate(block::tJ)
    if size(block) > 0
        b = _begin(block.cxx_block)
        return ProductState(_deref(b)), b
    else
        return nothing
    end
end

function Base.iterate(block::tJ, state)
    _incr(state)
    if state != _end(block.cxx_block)
        return ProductState(_deref(state)), state
    else
        return nothing
    end
end

# Output
Base.show(io::IO, block::tJ) = print(io, "\n" * to_string(block.cxx_block))
