# SPDX-FileCopyrightText: 2025 Alexander Wietek <awietek@pks.mpg.de>
#
# SPDX-License-Identifier: Apache-2.0

module XDiag

using Printf
using CxxWrap
using XDiag_jll
using LinearAlgebra

import Base: +, -, *, /, ==, !=
import Base: getindex, setindex!
import Base: size, isreal, convert, show, real, imag, push!, iterate, fill
import Base: rand, zeros, zero, isapprox, inv

import LinearAlgebra: dot, norm

@wrapmodule(XDiag_jll.get_libxdiagjl_path)

printlib() = println(XDiag_jll.get_libxdiagjl_path())
export printlib

# Utilities
export say_hello, print_version, set_verbosity
include("utils/armadillo.jl")

# Operators
include("operators/op.jl")
export Op, type, sites, to_string

include("operators/opsum.jl")
export OpSum, plain, constants

include("operators/hc.jl")
export hc

# Symmetries
include("symmetries/permutation.jl")
export Permutation, inv

include("symmetries/permutation_group.jl")
export PermutationGroup, nsites

include("symmetries/representation.jl")
export Representation

include("operators/symmetrize.jl")
export symmetrize

# Blocks
include("states/product_state.jl")
export ProductState

abstract type Block end
include("blocks/spinhalf.jl")
include("blocks/tj.jl")
include("blocks/electron.jl")
export Spinhalf, tJ, Electron, index, dim

# States
include("states/state.jl")
export State, vector, matrix, col, make_complex!, nrows, ncols

include("states/random_state.jl")
export RandomState, seed, normalized

include("states/gpwf.jl")
export GPWF

include("states/fill.jl")
export fill

include("states/create_state.jl")
export product_state, random_state, zero_state, zero

# Algebra
include("algebra/matrix.jl")
export matrix

include("algebra/apply.jl")
export apply

include("algebra/algebra.jl")
export norm, norm1, norminf, dot, inner

# Diagonalization
include("algorithms/sparse_diag.jl")
export eig0, eigval0

include("algorithms/lanczos/eigvals_lanczos.jl")
export eigvals_lanczos, eigvals_lanczos_inplace

include("algorithms/lanczos/eigs_lanczos.jl")
export eigs_lanczos

# Time evolution
include("algorithms/time_evolution/time_evolve.jl")
export time_evolve, time_evolve_inplace

include("algorithms/time_evolution/imaginary_time_evolve.jl")
export imaginary_time_evolve, imaginary_time_evolve_inplace

include("algorithms/time_evolution/time_evolve_expokit.jl")
export time_evolve_expokit, time_evolve_expokit_inplace

include("algorithms/time_evolution/evolve_lanczos.jl")
export evolve_lanczos, evolve_lanczos_inplace

# IO
include("io/file_toml.jl")
export FileToml

include("io/read.jl")
export read_permutation_group, read_representation, read_opsum

function __init__()
    @initcxx
end

end
