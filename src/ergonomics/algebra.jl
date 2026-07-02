# SPDX-License-Identifier: Apache-2.0
# Hand-written ergonomic layer: inner products, norms and apply with runtime
# real/complex dispatch (isreal -> real vs complex C++ overload). norm / dot
# extend LinearAlgebra; norm1 / norminf are generated (real return, no dispatch).

LinearAlgebra.norm(state::State) = cxx_norm(state.cxx_state)

function LinearAlgebra.dot(v::State, w::State)
    if isreal(v) && isreal(w)
        return cxx_dot(v.cxx_state, w.cxx_state)
    else
        return cxx_dotC(v.cxx_state, w.cxx_state)
    end
end

function matrix_dot(v::State, w::State)
    if isreal(v) && isreal(w)
        return to_julia(cxx_matrix_dot(v.cxx_state, w.cxx_state))
    else
        return to_julia(cxx_matrix_dotC(v.cxx_state, w.cxx_state))
    end
end

function inner(ops::OpSum, v::State)
    if isreal(ops) && isreal(v)
        return cxx_inner(ops.cxx_opsum, v.cxx_state)
    else
        return cxx_innerC(ops.cxx_opsum, v.cxx_state)
    end
end

function inner(op::Op, v::State)
    if isreal(op) && isreal(v)
        return cxx_inner(op.cxx_op, v.cxx_state)
    else
        return cxx_innerC(op.cxx_op, v.cxx_state)
    end
end

# apply(operator, state[, out]) -- CxxWrap returns the (wrapped) State directly.
apply(ops::OpSum, v::State) = State(cxx_apply(ops.cxx_opsum, v.cxx_state))
apply(op::Op, v::State) = State(cxx_apply(op.cxx_op, v.cxx_state))
apply(ops::OpSum, v::State, w::State) =
    cxx_apply(ops.cxx_opsum, v.cxx_state, w.cxx_state)
apply(op::Op, v::State, w::State) =
    cxx_apply(op.cxx_op, v.cxx_state, w.cxx_state)

# apply into caller-owned arma-backed arrays (zero-copy, in place).
function apply(ops::OpSum, block_in::B, vec_in::AbstractVecOrMat,
               block_out::B, vec_out::AbstractVecOrMat) where {B<:Block}
    with_armadillo(vec_in; copy = false) do vin
        with_armadillo(vec_out; copy = false) do vout
            cxx_apply(ops.cxx_opsum, block_in.cxx_block, vin,
                      block_out.cxx_block, vout)
        end
    end
    return vec_out
end
