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

    # out-of-place vs in-place (State-based apply)
    psi = random_state(block)
    v = apply(ops, psi)
    w = zero_state(block)
    apply(ops, psi, w)
    @test isapprox(vector(v), vector(w))

    psiC = random_state(block; real=false)
    vC = apply(ops, psiC)
    wC = zero_state(block; real=false)
    apply(ops, psiC, wC)
    @test isapprox(vector(vC), vector(wC))
end
