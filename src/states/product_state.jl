struct ProductState
    cxx_product_state::cxx_ProductState
end

# Constructors
ProductState() = ProductState(cxx_ProductState())
ProductState(n_sites::Int64) = ProductState(cxx_ProductState(n_sites))
ProductState(local_states::Vector{String}) = ProductState(cxx_ProductState(StdVector(StdString.(local_states))))

# Methods
n_sites(state::ProductState) = n_sites(state.cxx_product_state)
Base.size(state::ProductState) = size(state.cxx_product_state)
Base.getindex(state::ProductState, idx::Int64) = getindex(state.cxx_product_state, idx)
Base.setindex!(state::ProductState, local_state::String, idx::Int64) = setindex!(state.cxx_product_state, local_state, idx)
Base.push!(state::ProductState, local_state::String) = push!(state.cxx_product_state, local_state)
_begin(state::ProductState) = _begin(state.cxx_product_state)
_end(state::ProductState) = _end(state.cxx_product_state)

# Iterators
function Base.iterate(s::ProductState)
    if size(s) > 0
        return s[1], _begin(s)
    else
        return nothing
    end
end

function Base.iterate(s::ProductState, state) 
    _incr(state)
    if state == _end(s)
        return nothing
    else
        return _deref(state), state
    end
end
    
# Output
Base.show(io::IO, state::ProductState) = print(io, "\n" * to_string(state.cxx_product_state))
