# SPDX-FileCopyrightText: 2026 XDiag contributors
#
# SPDX-License-Identifier: Apache-2.0

@testset "Boson and Fermion blocks" begin
    # Boson without symmetry: `d` is the local dimension, dim = d^nsites
    b = Boson(2, 3)
    @test nsites(b) == 2
    @test d(b) == 3
    @test dim(b) == 9
    cnt = 0
    for _ in b
        cnt += 1
    end
    @test cnt == dim(b)
    @test nsites(Boson(2, 3, 2)) == 2        # fixed total boson number

    # Fermion without symmetry: spinless fermions
    f = Fermion(4)
    @test nsites(f) == 4
    @test dim(f) == 16
    cnt = 0
    for ps in f
        @test index(f, ps) == (cnt += 1)
    end
    @test cnt == dim(f)
    @test nsites(Fermion(4, 2)) == 4         # fixed particle number

    # with a cyclic-group symmetry (trivial k=0 irrep of C_N)
    N = 4
    group = cyclic_group(N)
    irrep = cyclic_group_irrep(N, 0)
    @test group isa PermutationGroup
    @test irrep isa Representation

    bsym = Boson(N, 2, irrep)
    @test nsites(bsym) == N
    idx = 1
    for ps in bsym
        @test index(bsym, ps) == idx
        idx += 1
    end

    fsym = Fermion(N, irrep)
    @test nsites(fsym) == N
    idx = 1
    for ps in fsym
        @test index(fsym, ps) == idx
        idx += 1
    end
end
