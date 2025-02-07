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

export say_hello, print_version, set_verbosity

include("utils/armadillo.jl")

include("operators/op.jl")
export Op, type, sites, to_string

include("operators/opsum.jl")
export OpSum, plain, constants

include("operators/hc.jl")
export hc

include("symmetries/permutation.jl")
export Permutation, inv

include("symmetries/permutation_group.jl")
export PermutationGroup, nsites

include("symmetries/representation.jl")
export Representation

include("operators/symmetrize.jl")
export symmetrize

include("states/product_state.jl")
export ProductState

abstract type Block end
include("blocks/spinhalf.jl")
include("blocks/tj.jl")
include("blocks/electron.jl")
export Spinhalf, tJ, Electron, index, dim

include("states/state.jl")
export State, vector, matrix, col, make_complex!, nrows, ncols

include("states/random_state.jl")
export RandomState, seed, normalized

include("states/gpwf.jl")
export GPWF

include("states/fill.jl")
export fill

include("states/create_state.jl")
export product

include("algebra/matrix.jl")
export matrix

include("algebra/apply.jl")
export apply

include("algebra/algebra.jl")
export norm, norm1, norminf, dot, inner

# include("algorithms/sparse_diag.jl")
# export eig0, eigval0

# include("algorithms/lanczos/eigvals_lanczos.jl")
# export eigvals_lanczos

# include("algorithms/lanczos/eigs_lanczos.jl")
# export eigs_lanczos

function __init__()
    @initcxx
end

end
