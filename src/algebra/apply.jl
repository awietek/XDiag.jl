# SPDX - FileCopyrightText : 2025 Alexander Wietek < awietek @pks.mpg.de>
#
# SPDX - License - Identifier : Apache - 2.0

apply(ops::OpSum, v::State, w::State) =
    cxx_apply(ops.cxx_opsum, v.cxx_state, w.cxx_state)

apply(op::Op, v::State, w::State) =
    cxx_apply(op.cxx_op, v.cxx_state, w.cxx_state)

apply(ops::OpSum, v::State)::State =
    cxx_apply(ops.cxx_opsum, v.cxx_state)

apply(op::Op, v::State)::State =
    cxx_apply(op.cxx_op, v.cxx_state)

function apply(ops::OpSum,
               block_in::B, vec_in::Vector{Float64},
               block_out::B, vec_out::Vector{Float64}) where B <: Block
    cxx_apply(ops.cxx_opsum,
              block_in.cxx_block, to_armadillo(vec_in; copy=false),
              block_out.cxx_block, to_armadillo(vec_out; copy=false))
end

function apply(ops::OpSum,
               block_in::B, vec_in::Vector{ComplexF64},
               block_out::B, vec_out::Vector{ComplexF64}) where B <: Block
    cxx_apply(ops.cxx_opsum,
              block_in.cxx_block, to_armadillo(vec_in; copy=false),
              block_out.cxx_block, to_armadillo(vec_out; copy=false))
end

function apply(ops::OpSum,
               block_in::B, mat_in::Matrix{Float64},
               block_out::B, mat_out::Matrix{Float64}) where B <: Block
    cxx_apply(ops.cxx_opsum,
              block_in.cxx_block, to_armadillo(mat_in; copy=false),
              block_out.cxx_block, to_armadillo(mat_out; copy=false))
end

function apply(ops::OpSum,
               block_in::B, mat_in::Matrix{ComplexF64},
               block_out::B, mat_out::Matrix{ComplexF64}) where B <: Block
    cxx_apply(ops.cxx_opsum,
              block_in.cxx_block, to_armadillo(mat_in; copy=false),
              block_out.cxx_block, to_armadillo(mat_out; copy=false))
end
