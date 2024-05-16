module XDiag

using CxxWrap
using XDiag_jll
using LinearAlgebra

import Base: +, *, getindex, setindex!

@wrapmodule(XDiag_jll.get_xdiagjl_path)
# @wrapmodule(() -> joinpath("/Users/awietek/Research/Software/xdiag/install/lib/","libxdiagjl"))

include("blocks.jl")
include("operators.jl")
include("matrix.jl")
include("sparse_diag.jl")
include("symmetries.jl")

export Spinhalf, tJ, Electron
export n_sites, Bond, BondList
export State, make_complex!, n_rows, n_cols, zeros_like
export matrix, col, apply, dot, inner, norm
export eig0, eigval0
export exp_sym_v
export add!
export Permutation, inverse

export say_hello, set_verbosity

function printlib()
    @show XDiag_jll.get_xdiagjl_path()
end



function apply(bonds::BondList, v::State, w::State)
    # convert bonds to BondList in C++ format
    bonds_cxx = bondlist_cxx(bonds)
    apply_cxx(bonds_cxx, v, w)
end

function dot(v::State, w::State)
    if isreal(v) && isreal(w)
        return dot_cxx(v, w)
    else
        return dotC_cxx(v, w)
    end
end

function inner(bonds::BondList, v::State)
    bonds_cxx = bondlist_cxx(bonds)
    if isreal(v) && isreal(bonds)
        return inner_cxx(bonds_cxx, v)
    else
        return innerC_cxx(bonds_cxx, v)
    end
end

function inner(v::State, bonds::BondList, w::State)
    bonds_cxx = bondlist_cxx(bonds)
    if isreal(v) && isreal(bonds) && isreal(w)
        return inner_cxx(v, bonds_cxx, w)
    else
        return innerC_cxx(v, bonds_cxx, w)
    end
end


function exp_sym_v(bonds::BondList, state::State, tau::Number;
                   normalize::Bool = false, shift::Float64 = 0., precision::Real = 1e-12,
                   max_iterations::Integer = 1000, deflation_tol::Real = 1e-7)
    bonds_cxx = bondlist_cxx(bonds)
    return exp_sym_v_cxx(bonds_cxx, state, tau, normalize, shift,
                         precision, max_iterations, deflation_tol)
end

function matrix(state::State; copy::Bool=true)
    sz = Base.size(state)

    # perform a copy of the data of the state
    if copy 
        if isreal(state)
            mat = Matrix{Float64}(undef, sz[1], sz[2])
            n = sz[1] * sz[2]
            destp = Base.unsafe_convert(Ptr{Cvoid}, mat)
            srcp = Ptr{Cvoid}(memptr(state).cpp_object)
            ccall(:memcpy, Ptr{Cvoid}, (Ptr{Cvoid}, Ptr{Cvoid}, Csize_t),
                  destp, srcp, n * Base.aligned_sizeof(Float64))
            return mat
        else
            mat = Matrix{ComplexF64}(undef, sz[1], sz[2])
            n = sz[1] * sz[2] * 2
            destp = Base.unsafe_convert(Ptr{Cvoid}, mat)
            srcp = Ptr{Cvoid}(memptr(state).cpp_object)
            ccall(:memcpy, Ptr{Cvoid}, (Ptr{Cvoid}, Ptr{Cvoid}, Csize_t),
                  destp, srcp, n * Base.aligned_sizeof(Float64))
            return mat
        end
    else
        if isreal(state)
            return unsafe_wrap(Matrix{Float64}, memptr(state).cpp_object, sz; own=false)
        else
            return unsafe_wrap(Matrix{ComplexF64}, memptrC(state).cpp_object, sz; own=false)
        end
    end
    
end

function col(state::State, ncol=1; copy::Bool=true)
    sz = Base.size(state)

    # perform a copy of the data of the state
    if copy
        if isreal(state)
            col = Vector{Float64}(undef, sz[1])
            n = sz[1] 
            destp = Base.unsafe_convert(Ptr{Cvoid}, col)
            srcp = Ptr{Cvoid}(colptr(state, ncol-1).cpp_object)
            ccall(:memcpy, Ptr{Cvoid}, (Ptr{Cvoid}, Ptr{Cvoid}, Csize_t),
                  destp, srcp, n * Base.aligned_sizeof(Float64))
            return col
        else
            col = Vector{ComplexF64}(undef, sz[1])
            n = sz[1] * 2
            destp = Base.unsafe_convert(Ptr{Cvoid}, col)
            srcp = Ptr{Cvoid}(colptr(state, ncol-1).cpp_object)
            ccall(:memcpy, Ptr{Cvoid}, (Ptr{Cvoid}, Ptr{Cvoid}, Csize_t),
                  destp, srcp, n * Base.aligned_sizeof(Float64))
            return col
        end
    else
        if isreal(state)
            return unsafe_wrap(Matrix{Float64}, colptr(state, ncol-1).cpp_object, sz; own=false)
        else
            return unsafe_wrap(Matrix{ComplexF64}, colptrC(state, ncol-1).cpp_object, sz; own=false)
        end
    end
end

function __init__()
    @initcxx
end

end
