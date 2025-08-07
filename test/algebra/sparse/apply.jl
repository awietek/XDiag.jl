# SPDX-FileCopyrightText: 2025 Alexander Wietek <awietek@pks.mpg.de>
#
# SPDX-License-Identifier: Apache-2.0

@testset "sparse_apply" begin
    N = 8
    block = Spinhalf(N,  N ÷ 2)
    ops = OpSum()
    for i in 1:N
        ops += Op("SdotS", [i, mod1(i+1, N)])
    end
    csr = csr_matrix(ops, block)
    csr32 = csr_matrix_32(ops, block)
    csrC = csr_matrixC(ops, block)
    csrC32 = csr_matrixC_32(ops, block)
    
    # vectors
    psi = random_state(block)
    r = vector(psi)
    v = apply(ops, psi)
    w = apply(csr, r)
    w_32 = apply(csr32, r)
    w2 = zeros(Float64, size(block))
    w2_32 = zeros(Float64, size(block))
    apply(csr, r, w2)
    apply(csr32, r, w2_32)
    @test isapprox(w, vector(v))
    @test isapprox(w_32, vector(v))
    @test isapprox(w2, vector(v))
    @test isapprox(w2_32, vector(v))
   
    psiC = random_state(block; real=false)
    rC = vector(psiC)
    vC = apply(ops, psiC)
    wC = apply(csr, rC)
    wCC = apply(csrC, rC)
    wC_32 = apply(csr32, rC)
    wC_32C = apply(csrC32, rC)
    w2C = zeros(ComplexF64, size(block))
    w2CC = zeros(ComplexF64, size(block))
    w2C_32 = zeros(ComplexF64, size(block))
    w2C_32C = zeros(ComplexF64, size(block))
    apply(csr, rC, w2C)
    apply(csrC, rC, w2CC)
    apply(csr32, rC, w2C_32)
    apply(csrC32, rC, w2C_32C)
    @test isapprox(vector(vC), wC)
    @test isapprox(vector(vC), wCC)
    @test isapprox(vector(vC), wC_32)
    @test isapprox(vector(vC), wC_32C)
    @test isapprox(vector(vC), w2C)
    @test isapprox(vector(vC), w2CC)
    @test isapprox(vector(vC), w2C_32)
    @test isapprox(vector(vC), w2C_32C)
end
