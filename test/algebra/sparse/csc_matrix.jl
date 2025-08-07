# SPDX-FileCopyrightText: 2025 Alexander Wietek <awietek@pks.mpg.de>
#
# SPDX-License-Identifier: Apache-2.0

@testset "csc_matrix" begin
    N = 8
    block = Spinhalf(N,  N ÷ 2)
    ops = OpSum()
    for i in 1:N
        ops += Op("SdotS", [i, mod1(i+1, N)])
    end

    mr = matrix(ops, block)
    for i0 in [0, 1]
        sr64 = csc_matrix(ops, block, i0)
        sr32 = csc_matrix_32(ops, block, i0)
        @test isapprox(mr, to_dense(sr64))
        @test isapprox(mr, to_dense(sr32))
        @test sr64.ishermitian
        @test sr32.ishermitian
    end
    
    mc = matrix(ops, block)
    for i0 in [0, 1]
        sc64 = csc_matrixC(ops, block, i0)
        sc32 = csc_matrixC_32(ops, block, i0)
        @test isapprox(mc, to_dense(sc64))
        @test isapprox(mc, to_dense(sc32))
        @test sc64.ishermitian
        @test sc32.ishermitian
    end
    
end
