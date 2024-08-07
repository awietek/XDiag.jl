@testset "algebra" begin
    N = 8
    block = Spinhalf(N,  N ÷ 2)
    ops = OpSum()
    for i in 1:N
        ops += Op("HB", 1.0, [i-1, i % N])
    end
    e0, psi = eig0(ops, block);

    n2 = norm(psi)
    n1 = norm1(psi)
    ni = norminf(psi)
    @test ni < n2
    @test n2 < n1
    
    @test isapprox(dot(psi, psi), 1.0)
    @test isapprox(e0, inner(ops, psi))
end
