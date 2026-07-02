# SPDX-License-Identifier: Apache-2.0
__precompile__(false)
module XDiag

using CxxWrap
using LinearAlgebra
using Printf

import Base: +, -, *, /, ==, !=, getindex, setindex!, size, isreal, convert,
             show, real, imag, push!, iterate, length, isapprox, inv, conj, abs,
             zero, adjoint, ^
import LinearAlgebra: dot, norm

# Load the compiled wrapper. For development set ENV["XDIAG_JL_LIB"] to a local
# libxdiagjl; otherwise fall back to the packaged XDiag_jll.
# NOTE: for the released package this becomes
# @wrapmodule(XDiag_jll.get_libxdiagjl_path); during development point
# ENV["XDIAG_JL_LIB"] at a locally-built libxdiagjl.
@wrapmodule(() -> ENV["XDIAG_JL_LIB"])

# Hand-written arma <-> Julia bridge (to_julia / to_armadillo / with_armadillo).
include("utils/armadillo.jl")

# Generated ergonomic layer: abstract Block + all wrapper structs first (so the
# forwarder files can be included in any order), then per-subsystem forwarders.
include("generated/types.jl")
for p in sort(readdir(joinpath(@__DIR__, "generated"); join = true))
    (endswith(p, ".jl") && !endswith(p, "types.jl")) && include(p)
end

# Hand-written specials (caller-allocated pointer fills for dense / sparse).
include("specials/dense.jl")
include("specials/sparse.jl")

# Hand-written ergonomic layer (real/complex dispatch, kwargs, result structs,
# Julia-idiom aliases) that the mechanical generator cannot infer.
include("ergonomics/aliases.jl")
include("ergonomics/operators.jl")
include("ergonomics/states.jl")
include("ergonomics/algebra.jl")
include("ergonomics/algorithms.jl")
include("ergonomics/sparse.jl")

function __init__()
    @initcxx
end

# Blocks & core types
export Block, Spinhalf, tJ, Electron, Boson, Fermion
export Op, OpSum, State, ProductState, RandomState, GPWF
export Permutation, PermutationGroup, Representation, FileToml
# Common methods
export nsites, dim, size, length, index, isreal, isapprox, sites, type, to_string
export nrows, ncols, make_complex, make_complex!, real, imag
export plain, hc, symmetrize
# States
export random_state, product_state, zero_state, fill, vector, matrix, col
# Algebra
export apply, inner, norm, norm1, norminf, dot, matrix_dot
# Sparse
export CSRMatrix, COOMatrix, CSCMatrix, to_dense
export csr_matrix, csr_matrix_32, coo_matrix, coo_matrix_32, csc_matrix, csc_matrix_32
# Diagonalization
export eig0, eigval0, eigs, eigs_lanczos, eigvals_lanczos, eigvals_lanczos_inplace
# Time evolution
export evolve_lanczos, evolve_lanczos_inplace, time_evolve, time_evolve_inplace
export imaginary_time_evolve, imaginary_time_evolve_inplace
export time_evolve_expokit, time_evolve_expokit_inplace
# IO
export read_permutation_group, read_representation, read_opsum

end # module
