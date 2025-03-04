using XDiag
using Test
using Random

    @testset "symmetries.jl" begin
    # multiplication, identity, inverse, power
    for n_sites = 1:8
        id = Permutation(n_sites)
        randomPerm = Permutation(Random.shuffle(Xoshiro(42), collect(1:n_sites)))
        randomInv = inv(randomPerm)
        @test id*randomPerm == randomPerm
        @test randomPerm*id == randomPerm
        @test randomPerm*randomInv == id
        @test randomInv*randomPerm == id
        @test randomPerm ^ 2 == randomPerm*randomPerm
    end

    # permutation group?

    # representation?

end