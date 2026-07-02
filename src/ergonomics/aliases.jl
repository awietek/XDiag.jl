# SPDX-License-Identifier: Apache-2.0
# Hand-written ergonomic layer: Julia-idiom aliases with no 1:1 C++ API entry.

# length == size for the containers exposed by the wrapper.
Base.length(x::Op) = size(x)
Base.length(x::OpSum) = size(x)
Base.length(x::State) = size(x)
Base.length(x::Permutation) = size(x)
Base.length(x::PermutationGroup) = size(x)
Base.length(b::Spinhalf) = size(b)
Base.length(b::tJ) = size(b)
Base.length(b::Electron) = size(b)
Base.length(b::Boson) = size(b)
Base.length(b::Fermion) = size(b)

# Permutation power: p^n == pow(p, n).
Base.:^(p::Permutation, n::Int64) = pow(p, n)

# make_complex! mutates the state in place (C++ make_complex).
make_complex!(state::State) = make_complex(state)
