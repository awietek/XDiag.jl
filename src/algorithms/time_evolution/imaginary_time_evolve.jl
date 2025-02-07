function imaginary_time_evolve(ops::OpSum, psi0::State, time::Float64; 
                               precision::Float64=1e-12, shift::Float64=0.0)::State
    return cxx_imaginary_time_evolve(ops.cxx_opsum, psi0.cxx_state, time, precision, shift)
end

function imaginary_time_evolve_inplace(ops::OpSum, psi0::State, time::Float64; 
                             precision::Float64 = 1e-12, shift::Float64=0.0)
    return cxx_imaginary_time_evolve_inplace(ops.cxx_opsum, psi0.cxx_state, time, precision, shift)
end
