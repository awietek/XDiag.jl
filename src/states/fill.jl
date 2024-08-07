fill(state::State, pstate::ProductState, ncol::Int64 = 1) =
    cxx_fill(state.cxx_state, pstate.cxx_product_state, ncol-1)
fill(state::State, rstate::RandomState, ncol::Int64 = 1) =
    cxx_fill(state.cxx_state, rstate.cxx_random_state, ncol-1)
fill(state::State, gpwf::GPWF, ncol::Int64 = 1) =
    cxx_fill(state.cxx_state, gpwf.cxx_gpwf, ncol-1)
