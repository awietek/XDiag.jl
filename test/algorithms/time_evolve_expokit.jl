# SPDX-FileCopyrightText: 2025 Alexander Wietek <awietek@pks.mpg.de>
#
# SPDX-License-Identifier: Apache-2.0

@testset "time_evolve_expokit" begin
    N = 8
    block = Spinhalf(N,  N ÷ 2)
    ops = OpSum()
    for i in 1:N
        ops += Op("SdotS", [i, mod1(i+1, N)])
    end

    r = random_state(block)

    N = 4
    blockc = Electron(N, 2, 2)
    opsc = OpSum()
    for i in 1:N
        opsc += (1.0 + 1.0im) * Op("Hop", [i, mod1(i+1, N)])
    end
    rC = random_state(blockc; real=false)

    
    csr = csr_matrix(ops, block)
    csr32 = csr_matrix_32(ops, block)
    csrC = csr_matrix(opsc, blockc)
    csrC32 = csr_matrix_32(opsc, blockc)

    psi = time_evolve_expokit(ops, r, 1.0)
    psicsr = time_evolve_expokit(csr, r, 1.0)
    psicsr32 = time_evolve_expokit(csr32, r, 1.0)
    psicsrC = time_evolve_expokit(csrC, rC, 1.0)
    psicsrC32 = time_evolve_expokit(csrC32, rC, 1.0)
    @test isapprox(psi.state, psicsr.state)
    @test isapprox(psi.state, psicsr32.state)
    @test isapprox(psicsrC.state, psicsrC32.state)

    psi = random_state(block; seed=42)
    time_evolve_expokit_inplace(ops, psi, 1.0)

    psicsr = random_state(block; seed=42)
    time_evolve_expokit_inplace(csr, psicsr, 1.0)

    psicsr32 = random_state(block; seed=42)
    time_evolve_expokit_inplace(csr32, psicsr32, 1.0)

    psicsrC = random_state(blockc; real=false, seed=42)
    time_evolve_expokit_inplace(csrC, psicsrC, 1.0)
    
    psicsrC32 = random_state(blockc; real=false, seed=42)
    time_evolve_expokit_inplace(csrC32, psicsrC32, 1.0)

    @test isapprox(psi, psicsr)
    @test isapprox(psi, psicsr32)
    @test isapprox(psicsrC, psicsrC32)
end
