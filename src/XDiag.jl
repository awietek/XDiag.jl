module XDiag

using Printf
using CxxWrap
using XDiag_jll

import Base: +, *, ==, !=, getindex, setindex!, size, isreal, convert, show, real, imag, push!, iterate, fill, rand, zeros, zero

@wrapmodule(XDiag_jll.get_libxdiagjl_path)

printlib() = println(XDiag_jll.get_libxdiagjl_path())
export printlib

export say_hello, print_version, set_verbosity

include("operators/coupling.jl")
export Coupling, type, isreal, ismatrix, isexplicit

include("operators/op.jl")
export Op, coupling, sites

include("operators/opsum.jl")
export OpSum, couplings, defined

include("symmetries/permutation.jl")
export Permutation, inverse

include("symmetries/permutation_group.jl")
export PermutationGroup, n_sites

include("symmetries/representation.jl")
export Representation

include("operators/symmetrize.jl")
export symmetrize

include("states/product_state.jl")
export ProductState, _begin, _end

abstract type Block end
include("blocks/spinhalf.jl")
include("blocks/tj.jl")
include("blocks/electron.jl")
export Spinhalf, tJ, Electron, n_up, n_dn, dim, permutation_group, irrep, index

include("states/state.jl")
export State, vector, matrix, col, make_complex!, n_rows, n_cols

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

include("algorithms/sparse_diag.jl")
export eig0, eigval0

include("algorithms/lanczos/eigvals_lanczos.jl")
export eigvals_lanczos

include("algorithms/lanczos/eigs_lanczos.jl")
export eigs_lanczos

function __init__()
    @initcxx
end

end
