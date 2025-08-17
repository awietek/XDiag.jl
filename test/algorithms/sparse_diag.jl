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

    e0 = eigval0(ops, block)

    N = 4
    blockc = Electron(N, 2, 2)
    opsc = OpSum()
    for i in 1:N
        opsc += (1.0 + 1.0im) * Op("Hop", [i, mod1(i+1, N)])
    end
    
    csrC = csr_matrix(opsc, blockc)
    csrC32 = csr_matrix_32(opsc, blockc)

    e0c = eigval0(opsc, blockc)
    
    @test isapprox(e0, eigval0(csr, block))
    @test isapprox(e0, eigval0(csr32, block))    
    @test isapprox(e0c, eigval0(csrC, blockc))    
    @test isapprox(e0c, eigval0(csrC32, blockc))

    e0, psi0 = eig0(ops, block)
    e0c, psi0c = eig0(opsc, blockc)
    e0csr, psi0csr = eig0(csr, block)
    e0csr32, psi0csr32 = eig0(csr32, block)
    e0csrC, psi0csrC = eig0(csrC, blockc)
    e0csrC32, psi0csrC32 = eig0(csrC32, blockc)
    @test isapprox(e0, e0csr)
    @test isapprox(e0, e0csr32)
    @test isapprox(e0c, e0csrC)
    @test isapprox(e0c, e0csrC32)
    @test isapprox(psi0, psi0csr)
    @test isapprox(psi0, psi0csr32)
    # @test isapprox(psi0c, psi0csrC)    
    # @test isapprox(psi0c, psi0csrC32)
end
