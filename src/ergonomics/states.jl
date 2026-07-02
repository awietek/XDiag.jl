# SPDX-License-Identifier: Apache-2.0
# Hand-written ergonomic layer: State accessors with real/complex dispatch.
#
# vector / matrix pick the real or complex C++ accessor at runtime from
# isreal(state); col is 1-based. (cxx_vector / cxx_vectorC / cxx_matrix /
# cxx_matrixC / cxx_col are the cxx_-prefixed generated registrations.)

# State construction & factories use keyword arguments (the C++ API is
# positional; construct_State / random_state / zero_state are the plain C++
# registrations kept via EXCLUDE_JULIA).
State() = State(construct_State())
State(block::Block; real::Bool = true, ncols::Int64 = 1) =
    State(construct_State(block.cxx_block, real, ncols))
State(block::Block, v::Vector{Float64}) =
    State(construct_State(block.cxx_block, to_armadillo(v)))
State(block::Block, v::Vector{ComplexF64}) =
    State(construct_State(block.cxx_block, to_armadillo(v)))
State(block::Block, m::Matrix{Float64}) =
    State(construct_State(block.cxx_block, to_armadillo(m)))
State(block::Block, m::Matrix{ComplexF64}) =
    State(construct_State(block.cxx_block, to_armadillo(m)))

random_state(block::Block; real::Bool = true, ncols::Int64 = 1,
             seed::Int64 = 42, normalized::Bool = true) =
    State(random_state(block.cxx_block, real, ncols, seed, normalized))

zero_state(block::Block; real::Bool = true, ncols::Int64 = 1) =
    State(zero_state(block.cxx_block, real, ncols))

function vector(state::State; n::Int64 = 1)
    if isreal(state)
        return to_julia(cxx_vector(state.cxx_state, n - 1, false))
    else
        return to_julia(cxx_vectorC(state.cxx_state, n - 1, false))
    end
end

function matrix(state::State)
    if isreal(state)
        return to_julia(cxx_matrix(state.cxx_state, false))
    else
        return to_julia(cxx_matrixC(state.cxx_state, false))
    end
end

col(state::State, n::Int64 = 1; copy::Bool = true) =
    State(cxx_col(state.cxx_state, n - 1, copy))
