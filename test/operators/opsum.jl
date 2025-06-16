# SPDX-FileCopyrightText: 2025 Alexander Wietek <awietek@pks.mpg.de>
#
# SPDX-License-Identifier: Apache-2.0

@testset "OpSum" begin
    ops = OpSum()
    ops += "T" * Op("Hop", [1, 2])
    ops += "T" * Op("Hop", [2, 3])
    ops += "T" * Op("Hop", [3, 4])
    ops["T"] = 1.0
    @test isapprox(ops, hc(ops))

    o = Op("asdf")
    os = OpSum()
    os = OpSum(123, o)
    os = OpSum(1.3, o)    
    os = OpSum(1.3 + 4.5im, o)    
    os = OpSum("J", o)    

    os = 2 * o
    os = 2.0 * o
    os = (2.0 + 3.0im) * o

    os = os * 2
    os = os * 2.0
    os = os * (2.0 + 3.0im)

    os = os / 2
    os = os / 2.0
    os = os / (2.0 + 3.0im)

    os = "J" * o

    N = 12
    J = 1.0
    h = 0.5
    Sx = [0.0 1.0; 1.0 0.0]

    ops1 = OpSum()
    for i in 1:N
        ops1 += J * Op("SzSz", [i, mod1(i+1, N)])
        ops1 += h * Op("Matrix", i, Sx)
    end

    ops2 = OpSum()
    for i in 1:N
        ops2 += "J" * Op("SzSz", [i, mod1(i+1, N)])
        ops2+= "h" * Op("Matrix", i, Sx)
    end
    ops2["J"] = J;
    ops2["h"] = h;
    
    @test isapprox(ops1, ops2)
    @test isapprox(ops1 + ops2, 2 * ops1)
end
