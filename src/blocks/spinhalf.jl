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
n_sites(block::Spinhalf) = n_sites(block.cxx_block)
n_up(block::Spinhalf) = n_up(block.cxx_block)
permutation_group(block::Spinhalf) = PermutationGroup(permutation_group((block.cxx_block)))
irrep(block::Spinhalf) = Representation(irrep(block.cxx_block))
Base.isreal(block::Spinhalf) = isreal(block.cxx_block)
dim(block::Spinhalf) = dim(block.cxx_block)
Base.size(block::Spinhalf) = size(block.cxx_block)
index(block::Spinhalf, pstate::ProductState) =
    Int64(index(block.cxx_block, pstate.cxx_product_state)) + 1

# Iterators
function Base.iterate(block::Spinhalf)
    if size(block) > 0
        b = _begin(block.cxx_block)
        return ProductState(_deref(b)), b
    else
        return nothing
    end
end

function Base.iterate(block::Spinhalf, state)
    _incr(state)
    if state != _end(block.cxx_block)
        return ProductState(_deref(state)), state
    else
        return nothing
    end
end

# Output
Base.show(io::IO, block::Spinhalf) = print(io, "\n" * to_string(block.cxx_block))
