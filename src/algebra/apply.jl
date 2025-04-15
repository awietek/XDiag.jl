# SPDX-FileCopyrightText: 2025 Alexander Wietek <awietek@pks.mpg.de>
#
# SPDX-License-Identifier: Apache-2.0

apply(ops::OpSum, v::State, w::State) =
    cxx_apply(ops.cxx_opsum, v.cxx_state, w.cxx_state)

apply(op::Op, v::State, w::State) =
    cxx_apply(op.cxx_op, v.cxx_state, w.cxx_state)

apply(ops::OpSum, v::State)::State =
    cxx_apply(ops.cxx_opsum, v.cxx_state)

apply(op::Op, v::State)::State =
    cxx_apply(op.cxx_op, v.cxx_state)
