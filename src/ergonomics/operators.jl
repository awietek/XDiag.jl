# SPDX-License-Identifier: Apache-2.0
# Hand-written ergonomic layer: OpSum coupling-constant access.
#
# OpSum::operator[](string) returns a Scalar& lvalue in C++; the two-way access
# is exposed through the cxx_opsum_get / cxx_opsum_set helpers (specials.cpp).

Base.setindex!(ops::OpSum, val::Number, name::String) =
    cxx_opsum_set(ops.cxx_opsum, name, val)
Base.getindex(ops::OpSum, name::String) = cxx_opsum_get(ops.cxx_opsum, name)
