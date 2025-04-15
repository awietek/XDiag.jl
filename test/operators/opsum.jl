# SPDX-FileCopyrightText: 2025 Alexander Wietek <awietek@pks.mpg.de>
#
# SPDX-License-Identifier: Apache-2.0

@testset "OpSum" begin
    ops = OpSum()
    ops += "T" * Op("Hop", [1, 2])
    ops += "T" * Op("Hop", [2, 3])
    ops += "T" * Op("Hop", [3, 4])
    ops["T"] = 1.0
    @test isapprox(ops, hc(ops))
end
