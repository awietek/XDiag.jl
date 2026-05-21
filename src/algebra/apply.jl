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
    with_armadillo(vec_in; copy=false) do vec_in_arma
        with_armadillo(vec_out; copy=false) do vec_out_arma
            cxx_apply(ops.cxx_opsum,
                      block_in.cxx_block, vec_in_arma,
                      block_out.cxx_block, vec_out_arma)
        end
    end
end

function apply(ops::OpSum,
               block_in::B, vec_in::Vector{ComplexF64},
               block_out::B, vec_out::Vector{ComplexF64}) where B <: Block
    with_armadillo(vec_in; copy=false) do vec_in_arma
        with_armadillo(vec_out; copy=false) do vec_out_arma
            cxx_apply(ops.cxx_opsum,
                      block_in.cxx_block, vec_in_arma,
                      block_out.cxx_block, vec_out_arma)
        end
    end
end

function apply(ops::OpSum,
               block_in::B, mat_in::Matrix{Float64},
               block_out::B, mat_out::Matrix{Float64}) where B <: Block
    with_armadillo(mat_in; copy=false) do mat_in_arma
        with_armadillo(mat_out; copy=false) do mat_out_arma
            cxx_apply(ops.cxx_opsum,
                      block_in.cxx_block, mat_in_arma,
                      block_out.cxx_block, mat_out_arma)
        end
    end
end

function apply(ops::OpSum,
               block_in::B, mat_in::Matrix{ComplexF64},
               block_out::B, mat_out::Matrix{ComplexF64}) where B <: Block
    with_armadillo(mat_in; copy=false) do mat_in_arma
        with_armadillo(mat_out; copy=false) do mat_out_arma
            cxx_apply(ops.cxx_opsum,
                      block_in.cxx_block, mat_in_arma,
                      block_out.cxx_block, mat_out_arma)
        end
    end
end
