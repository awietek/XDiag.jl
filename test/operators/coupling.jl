@testset "Coupling" begin
    c = Coupling("hello")
    # @show c, type(c), isexplicit(c)
    @test type(c) == "string"
    @test isexplicit(c) == false
    @test convert(String, c) == "hello"
    
    c = Coupling(1.0)
    # @show c, type(c), isreal(c), ismatrix(c), isexplicit(c)
    @test type(c) == "double"
    @test isreal(c) == true
    @test ismatrix(c) == false
    @test isexplicit(c) == true
    @test convert(Float64, c) == 1.0
    @test convert(ComplexF64, c) == 1.0 + 0.0im
    
    c = Coupling(2.0 + 3im)
    # @show c, type(c), isreal(c), ismatrix(c), isexplicit(c)
    @test type(c) == "complex"
    @test isreal(c) == false
    @test ismatrix(c) == false
    @test isexplicit(c) == true
    @test convert(ComplexF64, c) == 2.0 + 3.0im

    cm = [0.0 1.0; 2.0 0.0]
    c = Coupling(cm)
    # @show c, type(c), isreal(c), ismatrix(c), isexplicit(c)
    @test type(c) == "mat"
    @test isreal(c) == true
    @test ismatrix(c) == true
    @test isexplicit(c) == true
    @test cm == convert(Matrix{Float64}, c)

    cm = [0 -im; im 0.0]
    c = Coupling(cm)
    # @show c, type(c), isreal(c), ismatrix(c), isexplicit(c)
    @test type(c) == "cx_mat"
    @test isreal(c) == false
    @test ismatrix(c) == true
    @test isexplicit(c) == true
    @test cm == convert(Matrix{ComplexF64}, c)
end
