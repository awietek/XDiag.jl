struct GPWF
    cxx_gpwf::cxx_GPWF
end

# Constructors
GPWF() = GPWF(cxx_GPWF())
GPWF(mat::Matrix{Float64}, n_up::Int64 = -1) = GPWF(cxx_GPWF(to_armadillo(mat), n_up))
GPWF(mat::Matrix{ComplexF64}, n_up::Int64 = -1) = GPWF(cxx_GPWF(to_armadillo(mat), n_up))

# Methods
n_sites(state::GPWF) = n_sites(state.cxx_gpwf)
n_up(state::GPWF) = n_up(state.cxx_gpwf)
Base.isreal(state::GPWF) = isreal(state.cxx_gpwf)

# Output
Base.show(io::IO, state::GPWF) = print(io, "\n" * to_string(state.cxx_gpwf))
