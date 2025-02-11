@testset "Op" begin
    op = Op("Hop", [1, 2])
    @test type(op) == "Hop"
    @test size(op) == 2
    @test op[1] == 1
    @test op[2] == 2
    @test sites(op) == [1, 2]

    op = Op("Hop", [1, 2])
    @test type(op) == "Hop"
    @test size(op) == 2
    @test op[1] == 1
    @test op[2] == 2
    @test sites(op) == [1, 2]
    @test isreal(op) == true
end
