# SPDX-FileCopyrightText: 2025 Alexander Wietek <awietek@pks.mpg.de>
#
# SPDX-License-Identifier: Apache-2.0

@testset "apply" begin
    N = 8
    block = Spinhalf(N,  N ÷ 2)
    ops = OpSum()
    for i in 1:N
        ops += Op("SdotS", [i, mod1(i+1, N)])
    end

    # vectors
    psi = random_state(block)
    v = apply(ops, psi)
    w = zeros(Float64, size(block))
    apply(ops, block, vector(psi), block, w)
    @test isapprox(vector(v), w)

    psiC = random_state(block; real=false)
    vC = apply(ops, psiC)
    wC = zeros(ComplexF64, size(block))
    apply(ops, block, vector(psiC), block, wC)
    @test isapprox(vector(vC), wC)
end
