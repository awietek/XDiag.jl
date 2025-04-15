# SPDX-FileCopyrightText: 2025 Alexander Wietek <awietek@pks.mpg.de>
#
# SPDX-License-Identifier: Apache-2.0

symmetrize(op::Op, group::PermutationGroup)::OpSum =
    cxx_symmetrize(op.cxx_op, group.cxx_group)
symmetrize(op::Op, irrep::Representation)::OpSum =
    cxx_symmetrize(op.cxx_op, irrep.cxx_representation)
symmetrize(ops::OpSum, group::PermutationGroup)::OpSum =
    cxx_symmetrize(ops.cxx_opsum, group.cxx_group)
symmetrize(ops::OpSum, irrep::Representation)::OpSum =
    cxx_symmetrize(ops.cxx_opsum, irrep.cxx_representation)
