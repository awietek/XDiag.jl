# SPDX-FileCopyrightText: 2026 Alexander Wietek <awietek@pks.mpg.de>
#
# SPDX-License-Identifier: Apache-2.0

@testset "apply" begin

    b = Fermion(4, 2)
    ops = OpSum()
    ops += Op("Hop", [1, 2])
    ops += Op("Hop", [2, 3])
    ops += Op("Hop", [3, 4])
    ops += Op("Hop", [4, 1])

    # Real vector
    v = rand(Float64, size(b))
    w = zeros(Float64, size(b))
    apply(ops, b, v, b, w)

    sv = State(b, v)
    sw = apply(ops, sv)
    @test isapprox(vector(sw), w)

    # Complex vector
    v = rand(ComplexF64, size(b))
    w = zeros(ComplexF64, size(b))
    apply(ops, b, v, b, w)

    sv = State(b, v)
    sw = apply(ops, sv)
    @test isapprox(vector(sw), w)


    # Real matrix
    M = rand(Float64, size(b), 3)
    N = zeros(Float64, size(b), 3)
    apply(ops, b, M, b, N)

    SM = State(b, M)
    SN = apply(ops, SM)
    @test isapprox(matrix(SN), N)

    # Complex matrix
    M = rand(ComplexF64, size(b), 3)
    N = zeros(ComplexF64, size(b), 3)
    apply(ops, b, M, b, N)

    SM = State(b, M)
    SN = apply(ops, SM)
    @test isapprox(matrix(SN), N)
   
end
