# SPDX-FileCopyrightText: 2026 XDiag contributors
#
# SPDX-License-Identifier: Apache-2.0

@testset "Op/OpSum introspection" begin
    op = Op("SdotS", [1, 2])
    @test hassites(op)
    @test !hasmatrix(op)

    m = Op("Matrix", 1, [0.0 1.0; 1.0 0.0])
    @test hasmatrix(m)

    # Monomial from an Op; hermitian conjugate -> OpSum
    mono = Monomial(op)
    @test hc(op) isa OpSum
    @test hc(mono) isa OpSum

    ops = OpSum()
    ops += Op("Hop", [1, 2])
    @test plain(ops) isa OpSum
    @test hc(ops) isa OpSum
end
