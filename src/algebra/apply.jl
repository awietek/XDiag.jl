apply(ops::OpSum, v::State, w::State, precision::Float64 = 1e-12) =
    cxx_apply(ops.cxx_opsum, v.cxx_state, w.cxx_state, precision)

apply(op::Op, v::State, w::State, precision::Float64 = 1e-12) =
    cxx_apply(op.cxx_op, v.cxx_state, w.cxx_state, precision)
