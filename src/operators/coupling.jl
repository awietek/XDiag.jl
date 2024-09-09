include("../utils/armadillo.jl")

struct Coupling
    cxx_coupling::cxx_Coupling
end

# Constructors
Coupling() = Coupling(cxx_Coupling())
Coupling(name::String) = Coupling(cxx_Coupling(name))
Coupling(val::Float64) = Coupling(cxx_Coupling(val))
Coupling(val::ComplexF64) = Coupling(cxx_Coupling(val))
Coupling(mat::Matrix{Float64}) = Coupling(cxx_Coupling(to_armadillo(mat)))
Coupling(mat::Matrix{Int64}) = Coupling(convert(Matrix{Float64}, mat))
Coupling(mat::Matrix{ComplexF64}) = Coupling(cxx_Coupling(to_armadillo(mat)))
Coupling(mat::Matrix{Complex{Int64}}) = Coupling(convert(Matrix{ComplexF64}, mat))

# Methods
type(cpl::Coupling) = String(type(cpl.cxx_coupling))
isreal(cpl::Coupling) = Bool(isreal(cpl.cxx_coupling))
ismatrix(cpl::Coupling) = Bool(ismatrix(cpl.cxx_coupling))
isexplicit(cpl::Coupling) = Bool(isexplicit(cpl.cxx_coupling))

# Output
Base.show(io::IO, cpl::Coupling) = print(io, to_string(cpl.cxx_coupling))

# Conversion
function Base.convert(::Type{String}, cpl::Coupling)
    if is_string(cpl.cxx_coupling)
        return String(as_string(cpl.cxx_coupling))
    else
        error(@sprintf "Coupling is of type \"%s\" cannot be converted to type \"String\"" type(cpl))
    end
end

function Base.convert(::Type{Float64}, cpl::Coupling)
    if is_double(cpl.cxx_coupling)
        return Float64(as_double(cpl.cxx_coupling))
    else
        error(@sprintf "Coupling is of type \"%s\" cannot be converted to type \"Float64\"" type(cpl))
    end
end

function Base.convert(::Type{ComplexF64}, cpl::Coupling)
    if is_double(cpl.cxx_coupling) || is_complex(cpl.cxx_coupling)
        return ComplexF64(as_complex(cpl.cxx_coupling))
    else
        error(@sprintf "Coupling is of type \"%s\" cannot be converted to type \"ComplexF64\"" type(cpl))
    end
end

function Base.convert(::Type{Matrix{Float64}}, cpl::Coupling)
    if is_mat(cpl.cxx_coupling)
        return to_julia(as_mat(cpl.cxx_coupling))
    else
        error(@sprintf "Coupling is of type \"%s\" cannot be converted to type \"Matrix{Float64}\"" type(cpl))
    end
end

function Base.convert(::Type{Matrix{ComplexF64}}, cpl::Coupling)
    if is_mat(cpl.cxx_coupling) || is_cx_mat(cpl.cxx_coupling)
        return to_julia(as_cx_mat(cpl.cxx_coupling))
    else
        error(@sprintf "Coupling is of type \"%s\" cannot be converted to type \"Matrix{ComplexF64}\"" type(cpl))
    end
end
