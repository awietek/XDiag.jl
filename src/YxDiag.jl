module YxDiag
using CxxWrap
using Latlib
using LinearAlgebra

export Spinhalf, n_sites, Bond, BondList
export State, make_complex!, n_rows, n_cols, zeros_like
export matrix, col, apply, dot, inner, norm
export eig0, eigval0
export exp_sym_v

@wrapmodule("/home/awietek/Research/Software/hydra/build/julia/libhydrajl.so", :define_julia_module)

struct BondList
    bonds::Vector{Bond}
    couplings::Dict{AbstractString, Number}
end

BondList(bonds::Vector{Bond}) = BondList(bonds, Dict())

function bond_cxx(bond::Bond)
    if all(bond.sites .<= 0)
        error("Sites of bond must be >= 1") 
    end
    # sites in c++ start counting from 0
    sites = bond.sites .- 1
    return BondCxx(bond.type, bond.coupling, StdVector(sites))
end

function bondlist_cxx(bondlist::BondList)
    bonds_cxx = BondListCxx(StdVector(bond_cxx.(bondlist.bonds)))
    for (key, val) in bondlist.couplings
        set_coupling(bonds_cxx, key, ComplexF64(val))
    end
    return bonds_cxx
end

function Base.real(state::State)
    return real(state)
end

function LinearAlgebra.norm(state::State)
    return norm_cxx(state)
end

function Base.imag(state::State)
    return imag(state)
end

function Base.size(block::Spinhalf)
    return size(block)
end

function Base.size(state::State)
    return (n_rows(state), n_cols(state))
end

macro name(arg)
    x = string(arg)
    quote
        $x
    end
end

function Base.show(io::IO, block::Spinhalf)
    print_pretty("hydra::Spinhalf", block)
end

function Base.show(io::IO, state::State)
    print_pretty("hydra::State", state)
end

function Base.show(io::IO, bond::BondCxx)
    print_pretty("hydra::Bond", bond)
end

function Base.show(io::IO, bonds::BondListCxx)
    print_pretty("hydra::BondList", bonds)
end

# ground state energy routines
function eig0(bonds::BondList, block::Spinhalf;
              precision::Real=1e-12, maxiter::Integer=1000,
              force_complex::Bool=false, seed::Integer=42)
    bonds_cxx = bondlist_cxx(bonds)
    return eig0_cxx(bonds_cxx, block, precision, maxiter, force_complex, seed)
end

function eigval0(bonds::BondList, block::Spinhalf;
                 precision::Real=1e-12, maxiter::Integer=1000,
                 force_complex::Bool=false, seed::Integer=42)
    bonds_cxx = bondlist_cxx(bonds)
    return eigval0_cxx(bonds_cxx, block, precision, maxiter, force_complex, seed)
end


function matrix(bonds::BondList, block_in::Spinhalf, block_out::Spinhalf;
                force_complex::Bool=false)
    # convert bonds to BondList in C++ format
    bonds_cxx = bondlist_cxx(bonds)

    if isreal(bonds_cxx, 1e-12) && isreal(block_in, 1e-12) && isreal(block_out, 1e-12) && !force_complex
        mat = Matrix{Float64}(undef, size(block_in), size(block_out))
        matrix_cxx(Base.unsafe_convert(Ptr{Float64}, mat), bonds_cxx, block_in, block_out)
        return mat
    else
        mat = Matrix{ComplexF64}(undef, size(block_in), size(block_out))
        matrixC_cxx(Base.unsafe_convert(Ptr{ComplexF64}, mat), bonds_cxx, block_in, block_out)
        return mat
    end
end

function matrix(bonds::BondList, block::Spinhalf; force_complex::Bool=false)
    return matrix(bonds, block, block; force_complex=force_complex)
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
