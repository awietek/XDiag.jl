# SPDX-FileCopyrightText: 2026 XDiag contributors
#
# SPDX-License-Identifier: Apache-2.0

@testset "permutation/representation algebra" begin
    p1 = Permutation([1, 2, 3, 4])
    p2 = Permutation([2, 3, 4, 1])
    @test (p1 * p2) isa Permutation
    @test pow(p2, 2) == p2 * p2

    # cyclic group and its irreps
    N = 4
    group = cyclic_group(N)
    @test group isa PermutationGroup
    rep = cyclic_group_irrep(N, 0)
    @test rep isa Representation
    @test isreal(rep)
    @test is_charge(rep) isa Bool
    @test is_permutation(rep) isa Bool

    # tensor product of representations
    @test (rep * rep) isa Representation
end
