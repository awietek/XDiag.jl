struct Representation
    cxx_representation::cxx_Representation
end

# Constructors
function Representation(characters::Vector{<:Number})
    characters_cplx = Vector{ComplexF64}(characters)
    memptr = Base.unsafe_convert(Ptr{ComplexF64}, characters_cplx)
    n = length( characters_cplx)
    return Representation(cxx_Representation(memptr, n))
end

# Methods
Base.size(irrep::Representation) = size(irrep.cxx_representation)
Base.isreal(irrep::Representation; precision::Real=1e-12) = isreal(irrep.cxx_representation, precision)
Base.:*(r1::Representation, r2::Representation) = Representation(multiply(r1.cxx_representation, r2.cxx_representation))

# Output
Base.show(io::IO, irrep::Representation) = print(io, "\n" * to_string(irrep.cxx_representation))

