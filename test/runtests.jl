# SPDX-FileCopyrightText: 2025 Alexander Wietek <awietek@pks.mpg.de>
#
# SPDX-License-Identifier: Apache-2.0

using XDiag
using Test

include("utils/armadillo.jl")
include("utils/version.jl")

include("operators/op.jl")
include("operators/op_extra.jl")
include("operators/opsum.jl")

include("symmetries/symmetries.jl")
include("symmetries/representation.jl")

include("states/state.jl")
include("states/state_extra.jl")
include("blocks/blocks.jl")
include("blocks/boson_fermion.jl")
include("algebra/algebra.jl")
include("algebra/apply.jl")
include("algebra/sparse/coo_matrix.jl")
include("algebra/sparse/csr_matrix.jl")
include("algebra/sparse/csc_matrix.jl")
include("algebra/sparse/apply.jl")

include("io/io.jl")

include("kernels/apply.jl")

include("algorithms/eigs_lanczos.jl")
include("algorithms/eigvals_lanczos.jl")
include("algorithms/sparse_diag.jl")
include("algorithms/direct.jl")
include("algorithms/time_evolve.jl")
include("algorithms/imaginary_time_evolve.jl")
include("algorithms/evolve_lanczos.jl")
include("algorithms/time_evolve_expokit.jl")
