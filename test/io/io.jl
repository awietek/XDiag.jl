# SPDX-FileCopyrightText: 2026 XDiag contributors
#
# SPDX-License-Identifier: Apache-2.0

@testset "io: read from toml" begin
    fl = FileToml(joinpath(@__DIR__, "shastry.16.toml"))

    @test defined(fl, "Interactions")
    @test !defined(fl, "DoesNotExist")

    ops = read_opsum(fl, "Interactions")
    @test ops isa OpSum

    group = read_permutation_group(fl, "Symmetries")
    @test group isa PermutationGroup

    # irrep tag; group_tag defaults to "Symmetries"
    irrep = read_representation(fl, "Gamma.C1.A")
    @test irrep isa Representation
end
