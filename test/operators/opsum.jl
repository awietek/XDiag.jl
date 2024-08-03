@testset "OpSum" begin
    op1 = Op("HOP", "T", [1, 2])
    op2 = Op("HOP", "T", [2, 3])
    ops = OpSum([op1, op2])
    @test size(ops) == 2
    ops += Op("HOP", "T", [3, 4])
    @test size(ops) == 3
    # @test isexplicit(ops) == false

    ops2 = OpSum()
    ops2 += Op("HB", "J", [1, 2])
    ops2 += Op("HB", "J", [2, 3])
    ops2 += Op("HB", "J", [4, 5])
    J = 1.23
    ops2["J"] = J
    @test convert(Float64, ops2["J"]) == J
    @test size(ops2) == 3
    @test isexplicit(ops2) == false

    ops3 = OpSum()
    ops3 += Op("HB", 1.23, [0, 1])
    ops3 += Op("HB", 1.23, [1, 2])
    @test isexplicit(ops3)
end
