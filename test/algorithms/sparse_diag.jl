# SPDX-FileCopyrightText: 2025 Alexander Wietek <awietek@pks.mpg.de>
#
# SPDX-License-Identifier: Apache-2.0

@testset "sparse_diag" begin
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

    e0 = eigval0(ops, block)
    @test isapprox(e0, eigval0(csr, block))
    @test isapprox(e0, eigval0(csr32, block))    
    @test isapprox(e0, eigval0(csrC, block))    
    @test isapprox(e0, eigval0(csrC32, block))

    e0, psi0 = eig0(ops, block)
    e0csr, psi0csr = eig0(csr, block)
    e0csr32, psi0csr32 = eig0(csr32, block)
    e0csrC, psi0csrC = eig0(csr32, block)
    e0csrC32, psi0csrC32 = eig0(csr32, block)
    @test isapprox(e0, e0csr)
    @test isapprox(e0, e0csr32)
    @test isapprox(e0, e0csrC)
    @test isapprox(e0, e0csrC32)
    @test isapprox(psi0, psi0csr)
    @test isapprox(psi0, psi0csr32)
    @test isapprox(psi0csrC, psi0csr32)    
end
