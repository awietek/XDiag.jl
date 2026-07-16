# SPDX-FileCopyrightText: 2026 XDiag contributors
#
# SPDX-License-Identifier: Apache-2.0

@testset "state constructors and observables" begin
    block = Spinhalf(4, 2)

    z = zero_state(block)
    @test isapprox(norm(z), 0.0)

    r = random_state(block)
    @test isapprox(norm(r), 1.0)
    @test isreal(r)
    @test isvalid(r)

    # product_state: local states are 0-based occupation indices (not shifted)
    p = product_state(block, [0, 1, 0, 1])
    @test dim(p) == dim(block)
    @test isapprox(norm(p), 1.0)

    # RandomState descriptor + its getters
    rs = RandomState(seed=1234)
    @test seed(rs) == 1234
    @test normalized(rs)

    # ProductState object: build, query, index (1-based), iterate (yields Int64)
    ps = ProductState([0, 1, 0, 1])
    @test nsites(ps) == 4
    @test ps[1] == 0
    @test ps[2] == 1
    @test collect(ps) == [0, 1, 0, 1]

    # build a ProductState incrementally with push_back
    ps2 = ProductState()
    push_back(ps2, 0)
    push_back(ps2, 1)
    @test nsites(ps2) == 2

    # column extraction (1-based) on a multi-column state
    psi = random_state(block; ncols=3)
    @test ncols(psi) == 3
    @test ncols(col(psi, 1)) == 1

    # observables
    @test length(expect(r, "Sz")) == 4
    @test size(correlation_matrix(r, "Sz", "Sz")) == (4, 4)
    @test size(matrix_dot(psi, psi)) == (3, 3)
end
