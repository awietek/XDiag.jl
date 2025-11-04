using XDiag
using Test

function C_N_character(N::Int, k::Int, p::Int)
    exp(im * 2 * pi * k * p / N)
end

@testset "symmetries.jl" begin
    # multiplication, identity, inverse, power
    for n_sites = 2:8
        id = Permutation(n_sites)
        randomPerm = Permutation(circshift(collect(range(1, n_sites)), 3^n_sites))
        randomInv = inv(randomPerm)
        @test id*randomPerm == randomPerm
        @test randomPerm*id == randomPerm
        @test randomPerm*randomInv == id
        @test randomInv*randomPerm == id
        @test randomPerm ^ 2 == randomPerm*randomPerm
    end

    # permutation group
    p1 = Permutation([1, 2, 3, 4])
    p2 = Permutation([3, 4, 1, 2])
    C = PermutationGroup([p1, p2])

    # N = 10
    # T = Permutation(circshift(1:N, -2))
    # C_N = PermutationGroup([T^k for k in 0:(N-1)])
    
    # representation
    # periodic N-site Heisenberg antiferromagnet
    for N in  2:2:8

        H = OpSum()
        for i in 1:N
            H += "J" * Op("SdotS", [i, mod1(i+1, N)])
        end
        H["J"] = 1.0 

        # define spin correlator at "half-chain" distance
        corr_op = OpSum()
        corr_op += Op("SdotS", [1, N ÷ 2])

        # define shift by one site
        T = Permutation(circshift(1:N, -1))

        # define cyclic group
        C_N = PermutationGroup([T^k for k in 0:(N-1)])

        # define irreps from character tables, labelled by momentum (2pi/N ×) k
        character_table = [ [C_N_character(N, k, p) for p in 0:(N-1)] for k in 0:(N-1)]
        irreps = [ Representation(C_N, character_table[k]) for k in 1:N ]   
        # check all translation symmetry blocks
        e0 = Inf
        psi0 = nothing
        for k in eachindex(irreps)
            block = Spinhalf(N, irreps[k])
            e0k, psik = eig0(H, block)

            if  e0k < e0
                e0 = e0k
                psi0 = psik
            end
        end
        e00, psi00 = eig0(H, Spinhalf(N))

        # now the operator must be symmetrized!
        corr = inner(symmetrize(corr_op, C_N), psi0)
        corr0 = inner(corr_op, psi00)
        @test isapprox(e0, e00, rtol=1e-8, atol=1e-8)
        @test isapprox(corr, corr0, rtol=1e-3, atol=1e-3)
    end        
end
