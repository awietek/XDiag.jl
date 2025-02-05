hc(op::Op) = Op(cxx_hc(op.cxx_op))
hc(ops::OpSum) = OpSum(cxx_hc(ops.cxx_opsum))
