# ground state energy routines
function eig0(bonds::BondList, block::Union{Spinhalf,Electron,tJ};
              precision::Real=1e-12, maxiter::Integer=1000,
              force_complex::Bool=false, seed::Integer=42)
    bonds_cxx = cxx(bonds)
    return eig0_cxx(bonds_cxx, block, precision, maxiter, force_complex, seed)
end

function eigval0(bonds::BondList, block::Union{Spinhalf,Electron,tJ};
                 precision::Real=1e-12, maxiter::Integer=1000,
                 force_complex::Bool=false, seed::Integer=42)
    bonds_cxx = cxx(bonds)
    return eigval0_cxx(bonds_cxx, block, precision, maxiter, force_complex, seed)
end
