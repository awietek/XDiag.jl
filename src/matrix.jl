function matrix(bonds::BondList, block_in::Union{Spinhalf,tJ,Electron},
                block_out::Union{Spinhalf,tJ,Electron};
                force_complex::Bool=false)
    # convert bonds to BondList in C++ format
    bonds_cxx = cxx(bonds)
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

function matrix(bond::Bond, block_in::Union{Spinhalf,tJ,Electron},
                block_out::Union{Spinhalf,tJ,Electron};
                force_complex::Bool=false)
    bonds = BondList()
    bonds += bond
    matrix(bonds, block_in, block_out; force_complex=force_complex)
end

function matrix(bonds::BondList, block::Union{Spinhalf,tJ,Electron};
                force_complex::Bool=false)
    return matrix(bonds, block, block; force_complex=force_complex)
end

function matrix(bond::Bond, block::Union{Spinhalf,tJ,Electron};
                force_complex::Bool=false)
    bonds = BondList()
    bonds += bond    
    return matrix(bonds, block, block; force_complex=force_complex)
end
