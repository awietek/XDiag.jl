@testset "blocks" begin
    N = 4
    nup = 2
    ndn = 1

    p1 = Permutation([0, 1, 2, 3])
    p2 = Permutation([1, 2, 3, 0])
    p3 = Permutation([2, 3, 0, 1])
    p4 = Permutation([3, 0, 1, 2])
    group = PermutationGroup([p1, p2, p3, p4])
    rep = Representation([1, -1, 1, -1])
    block_sym = tJ(N, nup, ndn, group, rep)

    # Iteration
    idx = 1
    for pstate in block_sym
        @test index(block_sym, pstate) == idx
        # @show pstate
        idx += 1
    end


    block_sym = Electron(N, nup, ndn, group, rep)

    # Iteration
    idx = 1
    for pstate in block_sym
        @test index(block_sym, pstate) == idx
        # @show pstate
        idx += 1
    end

   block_sym = Spinhalf(N, nup, group, rep)

    # Iteration
    idx = 1
    for pstate in block_sym
        @test index(block_sym, pstate) == idx
        # @show pstate
        idx += 1
    end
    
    
end
