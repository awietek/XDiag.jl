# SPDX-FileCopyrightText: 2025 Alexander Wietek <awietek@pks.mpg.de>
#
# SPDX-License-Identifier: Apache-2.0

struct State
    cxx_state::cxx_State
end
convert(::Type{T}, cxx_state::cxx_State) where T<: State = State(cxx_state)


# Constructors
State(block::Block; real::Bool = true, n_cols::Int64 = 1) =
    State(cxx_State(block.cxx_block, real, n_cols))

function State(block::Block, vec::Vector{Float64})
    m = length(vec)
    if m != size(block)
        error("Vector and Block do not have the same size!")
    end

    memptr = Base.unsafe_convert(Ptr{Float64}, vec)
    State(cxx_State(block.cxx_block, memptr, 1, 1))
end

function State(block::Block, vec::Vector{ComplexF64})
    m = length(vec)
    if m != size(block)
        error("Vector and Block do not have the same size!")
    end

    memptr = Base.unsafe_convert(Ptr{ComplexF64}, vec)
    State(cxx_State(block.cxx_block, memptr, 1))
end

function State(block::Block, mat::Matrix{Float64})
    m = size(mat)[1]
    n = size(mat)[2]
    if m != size(block)
        error("First dimension of matrix and Block do not have the same size!")
    end

    memptr = Base.unsafe_convert(Ptr{Float64}, mat)
    State(cxx_State(block.cxx_block, memptr, n, 1))
end

function State(block::Block, mat::Matrix{ComplexF64})
    m = size(mat)[1]
    n = size(mat)[2]

    if m != size(block)
        error("First dimension of matrix and Block do not have the same size!")

    end

    memptr = Base.unsafe_convert(Ptr{ComplexF64}, mat)
    State(cxx_State(block.cxx_block, memptr, n))
end

# Methods
n_sites(state::State)::Int64 = n_sites(state.cxx_state)
Base.isreal(state::State)::Bool = isreal(state.cxx_state)
Base.real(state::State)::State = real(state.cxx_state)
Base.imag(state::State)::State = imag(state.cxx_state)
make_complex!(state::State) = make_complex(state.cxx_state)
dim(state::State)::Int64 = dim(state.cxx_state)
Base.size(state::State)::Int64 = size(state.cxx_state)
nrows(state::State)::Int64 = nrows(state.cxx_state)
ncols(state::State)::Int64 = ncols(state.cxx_state)
col(state::State, n::Int64 = 1; copy::Bool = true)::State = col(state.cxx_state, n - 1, copy)

function vector(state::State; n::Int64 = 1)
    if isreal(state)
        return to_julia(vector(state.cxx_state, n-1, false))
    else
        return to_julia(vectorC(state.cxx_state, n-1, false))
    end
end

function matrix(state::State)
    if isreal(state)
        return to_julia(matrix(state.cxx_state, false))
    else
        return to_julia(matrixC(state.cxx_state, false))
    end
end

Base.isapprox(v::State, w::State,
              rtol::Float64=1e-12, atol::Float64=1e-12)::Bool =
                  isapprox(v.cxx_state, w.cxx_state, rtol, atol)

# Output
to_string(state::State)::String = to_string(state.cxx_state)
Base.show(io::IO, state::State) = print(io, "\n" * to_string(state.cxx_state))
