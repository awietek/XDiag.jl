struct Electron <: Block
    cxx_block::cxx_Electron
end
convert(::Type{T}, block::cxx_Electron) where T <: Electron = Electron(block)

# Constructors
Electron() = Electron(cxx_Electron())
Electron(nsites::Int64, backend::String="auto") =
    Electron(cxx_Electron(nsites, backend))
Electron(nsites::Int64, nup::Int64, ndn::Int64, backend::String="auto") =
    Electron(cxx_Electron(nsites, nup, ndn, backend))
Electron(nsites::Int64, irrep::Representation, backend::String="auto") =
    Electron(cxx_Electron(nsites, irrep.cxx_representation, backend))
Electron(nsites::Int64, nup::Int64, ndn::Int64, irrep::Representation, backend::String="auto")=
    Electron(cxx_Electron(nsites, nup, ndn, irrep.cxx_representation, backend))

# Methods
nsites(block::Electron)::Int64 = nsites(block.cxx_block)
index(block::Electron, pstate::ProductState)::Int64 =
    Int64(index(block.cxx_block, pstate.cxx_product_state)) + 1
Base.isreal(block::Electron)::Bool = isreal(block.cxx_block)
dim(block::Electron)::Int64 = dim(block.cxx_block)
Base.size(block::Electron)::Int64 = size(block.cxx_block)

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
to_string(block::Electron)::String = to_string(block.cxx_block)
Base.show(io::IO, block::Electron) = print(io, "\n" * to_string(block.cxx_block))
