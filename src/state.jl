function Base.real(state::State)
    return real(state)
end

function LinearAlgebra.norm(state::State)
    return norm_cxx(state)
end

function Base.imag(state::State)
    return imag(state)
end

function Base.size(state::State)
    return (n_rows(state), n_cols(state))
end

function Base.show(io::IO, state::State)
    print_pretty("xdiag::State", state)
end
