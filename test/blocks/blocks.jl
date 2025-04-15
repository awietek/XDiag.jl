# SPDX-FileCopyrightText: 2025 Alexander Wietek <awietek@pks.mpg.de>
#
# SPDX-License-Identifier: Apache-2.0

@testset "blocks" begin
    N = 4
    nup = 2
    ndn = 1
    p1 = Permutation([1, 2, 3, 4])
    p2 = Permutation([2, 3, 4, 1])
    p3 = Permutation([3, 4, 1, 2])
    p4 = Permutation([4, 1, 2, 3])
    group = PermutationGroup([p1, p2, p3, p4])
    rep = Representation(group, [1.0, -1.0, 1.0, -1.0])

    @test isreal(rep)
    
    block_sym = tJ(N, nup, ndn, rep)

    # Iteration
    idx = 1
    for pstate in block_sym
        @test index(block_sym, pstate) == idx
        # @show pstate
        idx += 1
    end


    block_sym = Electron(N, nup, ndn, rep)

    # Iteration
    idx = 1
    for pstate in block_sym
        @test index(block_sym, pstate) == idx
        # @show pstate
        idx += 1
    end

   block_sym = Spinhalf(N, nup, rep)

    # Iteration
    idx = 1
    for pstate in block_sym
        @test index(block_sym, pstate) == idx
        # @show pstate
        idx += 1
    end
    
    
end
