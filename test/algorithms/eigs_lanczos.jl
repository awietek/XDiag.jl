@testset "eigs_lanczos" begin
    N = 8
    block = Spinhalf(N,  N ÷ 2)
    ops = OpSum()
    for i in 1:N
        ops += Op("SdotS", [i, mod1(i+1, N)])
    end

    res = eigs_lanczos(ops, block)

    psi0 = res.eigenvectors
    E = inner(ops, psi0)
    @test isapprox(E, res.eigenvalues[1])
end
