using XDiag
using Test

@testset "XDiag.jl" begin
    N = 12
    block = Spinhalf(N, N÷2)

    H = Bond[]
    for s in 1:N
        push!(H, Bond("HB", "J", [s, (s+1)%N]))
    end 
    e0 = eigval0(H, block)
    @test close(e0, 2.)
    
end
