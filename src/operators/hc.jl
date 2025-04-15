# SPDX-FileCopyrightText: 2025 Alexander Wietek <awietek@pks.mpg.de>
#
# SPDX-License-Identifier: Apache-2.0

hc(op::Op)::Op = cxx_hc(op.cxx_op)
hc(ops::OpSum)::OpSum = cxx_hc(ops.cxx_opsum)
