symmetrize(ops::OpSum, group::PermutationGroup) =
    OpSum(cxx_symmetrize(ops.cxx_opsum, group.cxx_group))
symmetrize(op::Op, group::PermutationGroup) =
    OpSum(cxx_symmetrize(op.cxx_op, group.cxx_group))
symmetrize(ops::OpSum, group::PermutationGroup, irrep::Representation) =
    OpSum(cxx_symmetrize(ops.cxx_opsum, group.cxx_group, irrep.cxx_representation))
symmetrize(op::Op, group::PermutationGroup, irrep::Representation) =
    OpSum(cxx_symmetrize(op.cxx_op, group.cxx_group, irrep.cxx_representation))
