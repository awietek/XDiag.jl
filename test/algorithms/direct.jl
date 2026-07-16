# SPDX-FileCopyrightText: 2026 XDiag contributors
#
# SPDX-License-Identifier: Apache-2.0

@testset "direct eigensolvers (eigs/eigvals/eigs_lobpcg)" begin
    N = 8
    block = Spinhalf(N, N ÷ 2)
    ops = OpSum()
    for i in 1:N
        ops += Op("SdotS", [i, mod1(i+1, N)])
    end
    e0 = eigval0(ops, block)

    vals = eigvals(ops, block, 1)
    @test isapprox(vals[1], e0)

    evs, psi = eigs(ops, block, 1)
    @test isapprox(evs[1], e0)
    @test isapprox(inner(ops, psi), e0)

    res = eigs_lobpcg(ops, block)
    @test isapprox(res.eigenvalues[1], e0; atol=1e-6)
end
