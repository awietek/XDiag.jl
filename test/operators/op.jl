# SPDX-FileCopyrightText: 2025 Alexander Wietek <awietek@pks.mpg.de>
#
# SPDX-License-Identifier: Apache-2.0

@testset "Op" begin
    op = Op("Hop", [1, 2])
    @test type(op) == "Hop"
    @test size(op) == 2
    @test op[1] == 1
    @test op[2] == 2
    @test [op[i] for i in 1:size(op)] == [1, 2]   # `sites` (std::vector) not wrapped

    op = Op("Hop", [1, 2])
    @test type(op) == "Hop"
    @test size(op) == 2
    @test op[1] == 1
    @test op[2] == 2
    @test [op[i] for i in 1:size(op)] == [1, 2]   # `sites` (std::vector) not wrapped
    @test isreal(op) == true


    op = Op("Matrix", 1, [0 -1.0im; 1.0im 0])
    @test !isreal(op)
    
    o = Op()
    o = Op("asdf")
    o = Op("asdf", 1)
    o = Op("asdf", [1, 2])
    o = Op("asdf", 1, [1.0 0.0; 0.0 1.0])
    o = Op("asdf", [1, 2], [1.0 0.0; 0.0 1.0])
    o = Op("asdf", 1, [1.0*im 0.0; 0.0 1.0])
    o = Op("asdf", [1, 2], [1.0*im 0.0; 0.0 1.0])
    o = Op("asdf", -1);
end

@testset "Op introspection" begin
    op = Op("SdotS", [1, 2])
    @test hassites(op)
    @test !hasmatrix(op)

    m = Op("Matrix", 1, [0.0 1.0; 1.0 0.0])
    @test hasmatrix(m)

    ops = OpSum()
    ops += Op("Hop", [1, 2])
    @test plain(ops) isa OpSum
end

@testset "Op hc and adjoint" begin
    op = Op("S+", 1)
    mono = Monomial(op)
    ops = (0.5 + 1.0im) * Op("S+", 1) + 2.0 * Op("Sz", 2)

    # every overload returns an OpSum
    for x in (op, mono, ops)
        @test hc(x) isa OpSum
        @test adjoint(x) isa OpSum
        @test x' isa OpSum
    end

    # adjoint is the hermitian conjugate and an involution
    @test hc(op) == op'
    @test hc(mono) == mono'
    @test hc(ops) == ops'
    @test (ops')' == ops

    # consistency with the dense matrices on a block
    block = Spinhalf(2)
    M = matrix(ops, block)
    @test matrix(ops', block) ≈ M'
    @test matrix((ops')', block) ≈ M
    Mop = matrix(op, block)
    @test matrix(op', block) ≈ Mop'
end
