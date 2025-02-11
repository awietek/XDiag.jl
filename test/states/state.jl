@testset "State" begin
    block = Spinhalf(2)
    v = [1.0, 2.0, 3.0, 4.0]
    psi1 = State(block, v)
    @test v == vector(psi1)
    @test isreal(psi1)
    make_complex!(psi1)
    @test !isreal(psi1)
    @test [1.0 + 0.0im, 2.0 + 0.0im, 3.0 + 0.0im, 4.0 + 0.0im] == vector(psi1)
    @test size(psi1) == 4
    @test dim(psi1) == 4
    
    psi2 = State(block, real=false, n_cols=3)
    @test all(isapprox.(matrix(psi2), 0.0))
    @test nrows(psi2) == 4
    @test ncols(psi2) == 3
    @test !isreal(psi2)

    v = [1.0+4.0im, 2.0+3.0im, 3.0+2.0im, 4.0+1.0im]
    psi3 = State(block, v)
    @test !isreal(psi3)
    @test vector(real(psi3)) == real(v)
    @test vector(imag(psi3)) == imag(v)
end
