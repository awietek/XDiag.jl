# SPDX-FileCopyrightText: 2025 Alexander Wietek <awietek@pks.mpg.de>
#
# SPDX-License-Identifier: Apache-2.0

@testset "eigs_lanczos" begin
    N = 8
    block = Spinhalf(N,  N ÷ 2)
    ops = OpSum()
    for i in 1:N
        ops += Op("SdotS", [i, mod1(i+1, N)])
    end

    res = eigs_lanczos(ops, block)
    psi0 = res.eigenvectors
    E = inner(ops, psi0)
    @test isapprox(E, res.eigenvalues[1])

    N = 4
    blockc = Electron(N, 2, 2)
    opsc = OpSum()
    for i in 1:N
        opsc += (1.0 + 1.0im) * Op("Hop", [i, mod1(i+1, N)])
    end
    resc = eigs_lanczos(opsc, blockc)
    psi0c = resc.eigenvectors
    Ec = inner(opsc, psi0c)
    @test isapprox(Ec, resc.eigenvalues[1])



    csr = csr_matrix(ops, block)
    csr32 = csr_matrix_32(ops, block)
    csrC = csr_matrix(opsc, blockc)
    csrC32 = csr_matrix_32(opsc, blockc)
    res_csr = eigs_lanczos(csr, block)
    res_csr32 = eigs_lanczos(csr32, block)
    res_csrC = eigs_lanczos(csrC, blockc)
    res_csrC32 = eigs_lanczos(csrC, blockc)

    @test isapprox(E, res_csr.eigenvalues[1])
    @test isapprox(E, res_csr32.eigenvalues[1])
    @test isapprox(Ec, res_csrC.eigenvalues[1])
    @test isapprox(Ec, res_csrC32.eigenvalues[1])


    r = random_state(block)
    rC = random_state(blockc; real=false)

    rres = eigs_lanczos(ops, r)
    rres_csr = eigs_lanczos(csr, r)
    rres_csr32 = eigs_lanczos(csr32, r)
    rres_csrC = eigs_lanczos(csrC, rC)
    rres_csrC32 = eigs_lanczos(csrC, rC)
    @test isapprox(E, rres.eigenvalues[1])
    @test isapprox(E, rres_csr.eigenvalues[1])
    @test isapprox(E, rres_csr32.eigenvalues[1])
    @test isapprox(Ec, rres_csrC.eigenvalues[1])
    @test isapprox(Ec, rres_csrC32.eigenvalues[1])
end
