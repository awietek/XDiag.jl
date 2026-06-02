# SPDX-FileCopyrightText: 2025 Alexander Wietek <awietek@pks.mpg.de>
#
# SPDX-License-Identifier: Apache-2.0

const _ArmadilloArray = Union{Matrix{Float64},Matrix{ComplexF64},Vector{Float64},Vector{ComplexF64}}

struct SafeArmadilloWrapper{T,CppObj}
    arma::CppObj
    owner::T
end

Base.getproperty(w::SafeArmadilloWrapper, sym::Symbol) =
    (sym === :arma || sym === :owner) ? getfield(w, sym) : getproperty(getfield(w, :arma), sym)
Base.propertynames(w::SafeArmadilloWrapper) = propertynames(getfield(w, :arma))
Base.unsafe_convert(::Type{Ptr{Cvoid}}, w::SafeArmadilloWrapper) =
    Base.unsafe_convert(Ptr{Cvoid}, getfield(w, :arma))

function _armadillo_wrapper(mat::Matrix{Float64}, copy::Bool)
    m, n = size(mat)
    return cxx_arma_mat(pointer(mat), m, n, copy, true)
end

function _armadillo_wrapper(mat::Matrix{ComplexF64}, copy::Bool)
    m, n = size(mat)
    return cxx_arma_cx_mat(pointer(mat), m, n, copy, true)
end

function _armadillo_wrapper(vec::Vector{Float64}, copy::Bool)
    return cxx_arma_vec(pointer(vec), length(vec), copy, true)
end

function _armadillo_wrapper(vec::Vector{ComplexF64}, copy::Bool)
    return cxx_arma_cx_vec(pointer(vec), length(vec), copy, true)
end

"""
    to_armadillo(array; copy=true)

Create a C++ Armadillo wrapper for a supported Julia vector or matrix.

When `copy=true`, the C++ object owns copied storage and the raw C++ wrapper is
returned. When `copy=false`, no data is copied; the returned
`SafeArmadilloWrapper` keeps `array` alive for as long as the wrapper exists.
"""
function to_armadillo(array::_ArmadilloArray; copy=true)
    if copy
        return _armadillo_wrapper(array, true)
    else
        arma = GC.@preserve array _armadillo_wrapper(array, false)
        return SafeArmadilloWrapper(arma, array)
    end
end

"""
    with_armadillo(f, array; copy=true)

Call `f` with a C++ Armadillo wrapper for `array`.

For `copy=false`, the Julia array is preserved for the constructor call and kept
alive by an internal `SafeArmadilloWrapper`. The callback receives the underlying
C++ object so existing CxxWrap methods dispatch normally. If the callback returns
that same object, this function returns the wrapper instead to preserve the
zero-copy storage lifetime.
"""
function with_armadillo(f::F, array::_ArmadilloArray; copy=true) where F
    wrapper = to_armadillo(array; copy)
    arma = wrapper isa SafeArmadilloWrapper ? wrapper.arma : wrapper
    result = f(arma)
    return result === arma && wrapper isa SafeArmadilloWrapper ? wrapper : result
end

function _unsafe_copy_to_julia!(dest::Vector{T}, src, n::Integer) where T
    GC.@preserve dest src begin
        Base.unsafe_copyto!(pointer(dest), memptr(src).cpp_object, n)
    end
    return dest
end

function _unsafe_copy_to_julia!(dest::Matrix{T}, src, n::Integer) where T
    GC.@preserve dest src begin
        Base.unsafe_copyto!(pointer(dest), memptr(src).cpp_object, n)
    end
    return dest
end

function to_julia(vec::SafeArmadilloWrapper)
    return to_julia(vec.arma)
end

function to_julia(vec::cxx_arma_vec)
    m = n_rows(vec)
    return _unsafe_copy_to_julia!(Vector{Float64}(undef, m), vec, m)
end

function to_julia(vec::cxx_arma_cx_vec)
    m = n_rows(vec)
    return _unsafe_copy_to_julia!(Vector{ComplexF64}(undef, m), vec, m)
end

function to_julia(mat::cxx_arma_mat)
    m = n_rows(mat)
    n = n_cols(mat)
    return _unsafe_copy_to_julia!(Matrix{Float64}(undef, m, n), mat, n_elem(mat))
end

function to_julia(mat::cxx_arma_cx_mat)
    m = n_rows(mat)
    n = n_cols(mat)
    return _unsafe_copy_to_julia!(Matrix{ComplexF64}(undef, m, n), mat, n_elem(mat))
end
