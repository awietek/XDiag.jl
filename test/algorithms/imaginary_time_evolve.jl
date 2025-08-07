# SPDX-FileCopyrightText: 2025 Alexander Wietek <awietek@pks.mpg.de>
#
# SPDX-License-Identifier: Apache-2.0

@testset "imaginary_time_evolve" begin
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

    psi = imaginary_time_evolve(ops, r, 1.0)
    psicsr = imaginary_time_evolve(csr, r, 1.0)
    psicsr32 = imaginary_time_evolve(csr32, r, 1.0)
    psicsrC = imaginary_time_evolve(csrC, r, 1.0)
    psicsrC32 = imaginary_time_evolve(csrC32, r, 1.0)
    @test isapprox(psi, psicsr)
    @test isapprox(psi, psicsr32)
    @test isapprox(psicsrC, psicsrC32)

    psi = random_state(block; seed=42)
    imaginary_time_evolve_inplace(ops, psi, 1.0)

    psicsr = random_state(block; seed=42)
    imaginary_time_evolve_inplace(csr, psicsr, 1.0)

    psicsr32 = random_state(block; seed=42)
    imaginary_time_evolve_inplace(csr32, psicsr32, 1.0)

    psicsrC = random_state(block; seed=42)
    imaginary_time_evolve_inplace(csrC, psicsrC, 1.0)
    
    psicsrC32 = random_state(block; seed=42)
    imaginary_time_evolve_inplace(csrC32, psicsrC32, 1.0)

    @test isapprox(psi, psicsr)
    @test isapprox(psi, psicsr32)
    @test isapprox(psicsrC, psicsrC32)
end
