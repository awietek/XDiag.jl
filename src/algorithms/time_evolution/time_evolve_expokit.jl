struct TimeEvolveExpokitResult
    error::Float64
    hump::Float64
    state::State
end
convert(::Type{T}, res::cxx_TimeEvolveExpokitResult) where T <: TimeEvolveExpokitResult =
    TimeEvolveExpokitResult(error(res), hump(res), state(res))

time_evolve_expokit(ops::OpSum, state::State, time::Float64;
                    precision::Float64=1e-12,
                    m::Int64 = 30, 
                    anorm::Float64 = 0.0,
                    nnorm::Int64 = 2)::TimeEvolveExpokitResult = 
    cxx_time_evolve_expokit(ops.cxx_opsum, state.cxx_state, time, precision,
                            m, anorm, nnorm)

struct TimeEvolveExpokitInplaceResult
    error::Float64
    hump::Float64
end
convert(::Type{T}, res::cxx_TimeEvolveExpokitInplaceResult) where T <: TimeEvolveExpokitInplaceResult =
    TimeEvolveExpokitInplaceResult(error(res), hump(res))


time_evolve_expokit_inplace(ops::OpSum, state::State, time::Float64;
                            precision::Float64=1e-12,
                            m::Int64 = 30, 
                            anorm::Float64 = 0.0,
                            nnorm::Int64 = 2)::TimeEvolveExpokitInplaceResult =
                                cxx_time_evolve_expokit_inplace(ops.cxx_opsum,
                                                                state.cxx_state,
                                                                time,
                                                                precision,
                                                                m,
                                                                anorm,
                                                                nnorm)

