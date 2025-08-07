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

    csr = csr_matrix(ops, block)
    csr32 = csr_matrix_32(ops, block)
    csrC = csr_matrixC(ops, block)
    csrC32 = csr_matrixC_32(ops, block)
    res_csr = eigvals_lanczos(csr, block)
    res_csr32 = eigvals_lanczos(csr32, block)
    res_csrC = eigvals_lanczos(csrC, block)
    res_csrC32 = eigvals_lanczos(csrC, block)

    @test isapprox(E, res_csr.eigenvalues[1])
    @test isapprox(E, res_csr32.eigenvalues[1])
    @test isapprox(E, res_csrC.eigenvalues[1])
    @test isapprox(E, res_csrC32.eigenvalues[1])


    r = random_state(block)
    rC = random_state(block; real=false)

    rres = eigvals_lanczos(ops, r)
    rres_csr = eigvals_lanczos(csr, r)
    rres_csr32 = eigvals_lanczos(csr32, r)
    rres_csrC = eigvals_lanczos(csrC, rC)
    rres_csrC32 = eigvals_lanczos(csrC, rC)
    @test isapprox(E, rres.eigenvalues[1])
    @test isapprox(E, rres_csr.eigenvalues[1])
    @test isapprox(E, rres_csr32.eigenvalues[1])
    @test isapprox(E, rres_csrC.eigenvalues[1])
    @test isapprox(E, rres_csrC32.eigenvalues[1])

    r = random_state(block)
    irres = eigvals_lanczos_inplace(ops, r)
    @test isapprox(E, irres.eigenvalues[1])

    r = random_state(block)
    irres = eigvals_lanczos_inplace(csr, r)
    @test isapprox(E, irres.eigenvalues[1])

    r = random_state(block)
    irres = eigvals_lanczos_inplace(csr32, r)
    @test isapprox(E, irres.eigenvalues[1])

    rC = random_state(block)
    irres = eigvals_lanczos_inplace(ops, rC)
    @test isapprox(E, irres.eigenvalues[1])

    rC = random_state(block)
    irres = eigvals_lanczos_inplace(csrC, rC)
    @test isapprox(E, irres.eigenvalues[1])

    rC = random_state(block)
    irres = eigvals_lanczos_inplace(csrC32, rC)
    @test isapprox(E, irres.eigenvalues[1])    
    
end
