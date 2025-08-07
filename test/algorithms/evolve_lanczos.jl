# SPDX-FileCopyrightText: 2025 Alexander Wietek <awietek@pks.mpg.de>
#
# SPDX-License-Identifier: Apache-2.0

@testset "evolve_lanczos" begin
    N = 8
    block = Spinhalf(N,  N ÷ 2)
    ops = OpSum()
    for i in 1:N
        ops += Op("SdotS", [i, mod1(i+1, N)])
    end

    r = random_state(block)

    csr = csr_matrix(ops, block)
    csr32 = csr_matrix_32(ops, block)
    csrC = csr_matrixC(ops, block)
    csrC32 = csr_matrixC_32(ops, block)

    # real
    psi = evolve_lanczos(ops, r, 1.0)
    psicsr = evolve_lanczos(csr, r, 1.0)
    psicsr32 = evolve_lanczos(csr32, r, 1.0)
    psicsrC = evolve_lanczos(csrC, r, 1.0)
    psicsrC32 = evolve_lanczos(csrC32, r, 1.0)
    @test isapprox(psi.state, psicsr.state)
    @test isapprox(psi.state, psicsr32.state)
    @test isapprox(psicsrC.state, psicsrC32.state)

    psi = random_state(block; seed=42)
    evolve_lanczos_inplace(ops, psi, 1.0)

    psicsr = random_state(block; seed=42)
    evolve_lanczos_inplace(csr, psicsr, 1.0)

    psicsr32 = random_state(block; seed=42)
    evolve_lanczos_inplace(csr32, psicsr32, 1.0)

    psicsrC = random_state(block; seed=42)
    evolve_lanczos_inplace(csrC, psicsrC, 1.0)
    
    psicsrC32 = random_state(block; seed=42)
    evolve_lanczos_inplace(csrC32, psicsrC32, 1.0)

    @test isapprox(psi, psicsr)
    @test isapprox(psi, psicsr32)
    @test isapprox(psicsrC, psicsrC32)


    # cplx
    psi = evolve_lanczos(ops, r, 1.0im)
    psicsr = evolve_lanczos(csr, r, 1.0im)
    psicsr32 = evolve_lanczos(csr32, r, 1.0im)
    psicsrC = evolve_lanczos(csrC, r, 1.0im)
    psicsrC32 = evolve_lanczos(csrC32, r, 1.0im)
    @test isapprox(psi.state, psicsr.state)
    @test isapprox(psi.state, psicsr32.state)
    @test isapprox(psicsrC.state, psicsrC32.state)

    psi = random_state(block; seed=42)
    evolve_lanczos_inplace(ops, psi, 1.0im)

    psicsr = random_state(block; seed=42)
    evolve_lanczos_inplace(csr, psicsr, 1.0im)

    psicsr32 = random_state(block; seed=42)
    evolve_lanczos_inplace(csr32, psicsr32, 1.0im)

    psicsrC = random_state(block; seed=42)
    evolve_lanczos_inplace(csrC, psicsrC, 1.0im)
    
    psicsrC32 = random_state(block; seed=42)
    evolve_lanczos_inplace(csrC32, psicsrC32, 1.0im)

    @test isapprox(psi, psicsr)
    @test isapprox(psi, psicsr32)
    @test isapprox(psicsrC, psicsrC32)
end
