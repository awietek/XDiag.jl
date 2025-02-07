struct RandomState
    cxx_random_state::cxx_RandomState
end

# Constructors
RandomState(seed::Int64 = 42, normalized::Bool = true) = RandomState(cxx_RandomState(seed, normalized))

# Methods
seed(state::RandomState) = seed(state.cxx_random_state)
normalized(state::RandomState) = seed(state.cxx_random_state)
    
# Output
to_string(state::RandomState)::String = to_string(state.cxx_random_state)
Base.show(io::IO, state::RandomState) = print(io, "\n" * to_string(state.cxx_random_state))
