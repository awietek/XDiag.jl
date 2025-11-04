# SPDX-FileCopyrightText: 2025 Alexander Wietek <awietek@pks.mpg.de>
#
# SPDX-License-Identifier: Apache-2.0

@testset "eigvals_lanczos" begin
    N = 8
    block = Spinhalf(N,  N ÷ 2)
    ops = OpSum()
    for i in 1:N
        ops += Op("SdotS", [i, mod1(i+1, N)])
    end

    res = eigvals_lanczos(ops, block)
    E = res.eigenvalues[1]


    N = 4
    blockc = Electron(N, 2, 2)
    opsc = OpSum()
    for i in 1:N
        opsc += (1.0 + 1.0im) * Op("Hop", [i, mod1(i+1, N)])
    end
    resc = eigs_lanczos(opsc, blockc)
    Ec = resc.eigenvalues[1]

    csr = csr_matrix(ops, block)
    csr32 = csr_matrix_32(ops, block)
    csrC = csr_matrix(opsc, blockc)
    csrC32 = csr_matrix_32(opsc, blockc)
    res_csr = eigvals_lanczos(csr, block)
    res_csr32 = eigvals_lanczos(csr32, block)
    res_csrC = eigvals_lanczos(csrC, blockc)
    res_csrC32 = eigvals_lanczos(csrC32, blockc)

    @test isapprox(E, res_csr.eigenvalues[1])
    @test isapprox(E, res_csr32.eigenvalues[1])
    @test isapprox(Ec, res_csrC.eigenvalues[1])
    @test isapprox(Ec, res_csrC32.eigenvalues[1])

    r = random_state(block)
    rC = random_state(blockc; real=false)

    rres = eigvals_lanczos(ops, r)
    rres_csr = eigvals_lanczos(csr, r)
    rres_csr32 = eigvals_lanczos(csr32, r)
    rres_csrC = eigvals_lanczos(csrC, rC)
    rres_csrC32 = eigvals_lanczos(csrC, rC)
    @test isapprox(E, rres.eigenvalues[1])
    @test isapprox(E, rres_csr.eigenvalues[1])
    @test isapprox(E, rres_csr32.eigenvalues[1])
    @test isapprox(Ec, rres_csrC.eigenvalues[1])
    @test isapprox(Ec, rres_csrC32.eigenvalues[1])

    r = random_state(block)
    irres = eigvals_lanczos_inplace(ops, r)
    @test isapprox(E, irres.eigenvalues[1])

    r = random_state(block)
    irres = eigvals_lanczos_inplace(csr, r)
    @test isapprox(E, irres.eigenvalues[1])

    r = random_state(block)
    irres = eigvals_lanczos_inplace(csr32, r)
    @test isapprox(E, irres.eigenvalues[1])

    rC = random_state(blockc)
    irres = eigvals_lanczos_inplace(opsc, rC)
    @test isapprox(Ec, irres.eigenvalues[1])

    rC = random_state(blockc)
    irres = eigvals_lanczos_inplace(csrC, rC)
    @test isapprox(Ec, irres.eigenvalues[1])

    rC = random_state(blockc)
    irres = eigvals_lanczos_inplace(csrC32, rC)
    @test isapprox(Ec, irres.eigenvalues[1])    
    
end
