# SPDX-FileCopyrightText: 2026 XDiag contributors
#
# SPDX-License-Identifier: Apache-2.0

@testset "armadillo array bridge" begin
    # to_armadillo copies a Julia array into an arma object; to_julia copies it
    # back. Round-tripping exercises the pointer/element-type bridge directly.
    @testset "vector/matrix round-trip" begin
        for v in ([1.0, 2.0, 3.0], ComplexF64[1 + 2im, 3 - 4im])
            @test XDiag.to_julia(XDiag.to_armadillo(v)) == v
        end
        for m in ([1.0 2.0; 3.0 4.0], ComplexF64[1+1im 2; 3 4-1im])
            @test XDiag.to_julia(XDiag.to_armadillo(m)) == m
        end
    end

    # Public entry points that marshal dense arrays across the bridge.
    @testset "dense representation" begin
        block = Spinhalf(2)
        ops = OpSum()
        ops += Op("SdotS", [1, 2])
        mr = matrix(ops, block)
        @test mr isa Matrix{Float64}
        @test to_dense(csr_matrix(ops, block)) ≈ mr

        opsc = OpSum()
        opsc += 1.0im * Op("SdotS", [1, 2])
        mc = matrix(opsc, block)
        @test mc isa Matrix{ComplexF64}
        @test to_dense(csr_matrix(opsc, block)) ≈ mc
    end
end
