# SPDX-FileCopyrightText: 2026 XDiag contributors
#
# SPDX-License-Identifier: Apache-2.0

@testset "armadillo scoped helpers" begin
    block = Spinhalf(2)
    ops = OpSum()
    ops += Op("SdotS", [1, 2])
    dense = matrix(ops, block)

    @testset "with_armadillo preserves zero-copy vector apply semantics" begin
        vin = [0.0, 1.0, 0.0, 0.0]
        w_existing = zeros(Float64, 4)
        w_scoped = zeros(Float64, 4)

        apply(ops, block, vin, block, w_existing)

        XDiag.with_armadillo(vin; copy=false) do vin_arma
            XDiag.with_armadillo(w_scoped; copy=false) do w_arma
                XDiag.cxx_apply(ops.cxx_opsum, block.cxx_block, vin_arma,
                                block.cxx_block, w_arma)
            end
        end

        @test w_scoped == w_existing
        @test w_scoped ≈ dense * vin
    end

    @testset "with_armadillo preserves zero-copy matrix apply semantics" begin
        min = [0.0 1.0; 1.0 0.0; 0.0 0.0; 0.0 0.0]
        mout_existing = zeros(Float64, 4, 2)
        mout_scoped = zeros(Float64, 4, 2)

        apply(ops, block, min, block, mout_existing)

        XDiag.with_armadillo(min; copy=false) do min_arma
            XDiag.with_armadillo(mout_scoped; copy=false) do mout_arma
                XDiag.cxx_apply(ops.cxx_opsum, block.cxx_block, min_arma,
                                block.cxx_block, mout_arma)
            end
        end

        @test mout_scoped == mout_existing
        @test mout_scoped ≈ dense * min
    end

    @testset "with_cxx_csr_matrix preserves CSR dense conversion" begin
        csr = csr_matrix(ops, block)
        scoped_dense = XDiag.with_cxx_csr_matrix(csr) do cxx_csr
            XDiag.to_julia(XDiag.cxx_to_dense(cxx_csr))
        end

        @test scoped_dense == to_dense(csr)
        @test scoped_dense ≈ dense
    end
end

@testset "rectangular block in/out bridge order" begin
    N = 4
    block_in = Spinhalf(N, 1)
    block_out = Spinhalf(N, 2)
    ops = OpSum(Op("S+", 1))

    @test size(block_in) == 4
    @test size(block_out) == 6

    dense = matrix(ops, block_in, block_out)
    @test size(dense) == (size(block_in), size(block_out))

    vin = collect(1.0:size(block_in))
    expected_w = [2.0, 3.0, 0.0, 4.0, 0.0, 0.0]

    w = zeros(Float64, size(block_out))
    apply(ops, block_in, vin, block_out, w)
    @test w == expected_w

    expected_sparse_dense = [
        0.0 1.0 0.0 0.0
        0.0 0.0 1.0 0.0
        0.0 0.0 0.0 0.0
        0.0 0.0 0.0 1.0
        0.0 0.0 0.0 0.0
        0.0 0.0 0.0 0.0
    ]

    for constructor in (coo_matrix, coo_matrix_32,
                        csr_matrix, csr_matrix_32,
                        csc_matrix, csc_matrix_32)
        sparse = constructor(ops, block_in, block_out)
        @test (Int(sparse.nrows), Int(sparse.ncols)) == (size(block_out), size(block_in))
        @test to_dense(sparse) == expected_sparse_dense
    end

    csr = csr_matrix(ops, block_in, block_out)
    @test apply(csr, vin) == expected_w
end
