product(block::Block, local_states::Vector{String}, real::Bool=true) =  State(cxx_product(block.cxx_block, StdVector(StdString.(local_states)), real))

Base.rand(block::Block, real::Bool=true, seed::Int64=42, normalized::Bool=true) =
    State(cxx_rand(block.cxx_block, real, seed, normalized))

Base.zeros(block::Block, real::Bool=true, n_col::Int64=1) =
    State(cxx_zeros(block.cxx_block, real, n_col))

Base.zero(state::State) = cxx_zero(state.cxx_state)
