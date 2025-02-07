function time_evolve_expokit(ops::OpSum, state::State, time::Float64;
                             precision::Float=1e-12, m::Int64 = 30, 
                             anorm::Float64 = 0.0, nnorm::Int64 = 2)
    return cxx_time_evolve_expokit(ops.cxx_opsum, state.cxx_state, time, precision,
                                   m, anorm, nnorm)
end

function time_evolve_expokit_inplace(ops::OpSum, state::State, time::Float64;
                                     precision::Float=1e-12, m::Int64 = 30, 
                                     anorm::Float64 = 0.0, nnorm::Int64 = 2)
    cxx_time_evolve_expokit_inplace(ops.cxx_opsum, state.cxx_state, time, precision,
                                    m, anorm, nnorm)
end
