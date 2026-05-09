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
