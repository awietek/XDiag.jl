@testset "Op" begin
    op = Op("HOP", "T", [1, 2])
    @test type(op) == "HOP"
    @test convert(String, coupling(op)) == "T"
    @test size(op) == 2
    @test op[1] == 1
    @test op[2] == 2
    @test sites(op) == [1, 2]
    @test isexplicit(op) == false

    c = 1.23
    op = Op("HOP", c, [1, 2])
    @test type(op) == "HOP"
    @test convert(Float64, coupling(op)) == c
    @test size(op) == 2
    @test op[1] == 1
    @test op[2] == 2
    @test sites(op) == [1, 2]
    @test isreal(op) == true
    @test ismatrix(op) == false
    @test isexplicit(op) == true

    c = 3.21 + 1.23im
    op = Op("HOP", c, [1, 2])
    @test type(op) == "HOP"
    @test convert(ComplexF64, coupling(op)) == c
    @test size(op) == 2
    @test op[1] == 1
    @test op[2] == 2
    @test sites(op) == [1, 2]
    @test isreal(op) == false
    @test ismatrix(op) == false
    @test isexplicit(op) == true

    c = [0 1; 1 0]
    op = Op("HOP", c, [1, 2])
    @test type(op) == "HOP"
    @test convert(Matrix{Float64}, coupling(op)) == convert(Matrix{Float64}, c)
    @test size(op) == 2
    @test op[1] == 1
    @test op[2] == 2
    @test sites(op) == [1, 2]
    @test isreal(op) == true
    @test ismatrix(op) == true
    @test isexplicit(op) == true

    c = [0 -im; im 0]
    op = Op("HOP", c, [1, 2])
    @test type(op) == "HOP"
    @test convert(Matrix{ComplexF64}, coupling(op)) == convert(Matrix{ComplexF64}, c)
    @test size(op) == 2
    @test op[1] == 1
    @test op[2] == 2
    @test sites(op) == [1, 2]
    @test isreal(op) == false
    @test ismatrix(op) == true
    @test isexplicit(op) == true

end
