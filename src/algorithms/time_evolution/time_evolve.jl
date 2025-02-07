function time_evolve(ops::OpSum, psi0::State, time::Float64; 
                     precision::Float64 = 1e-12, algorithm::String = "lanczos")::State
    return cxx_time_evolve(ops.cxx_opsum, psi0.cxx_state, time, precision, algorithm)
end

function time_evolve_inplace(ops::OpSum, psi0::State, time::Float64; 
                             precision::Float64 = 1e-12, algorithm::String = "lanczos")
    return cxx_time_evolve_inplace(ops.cxx_opsum, psi0.cxx_state, time, precision, algorithm)
end
