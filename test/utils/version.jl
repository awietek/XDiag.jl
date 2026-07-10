# SPDX-FileCopyrightText: 2026 XDiag contributors
#
# SPDX-License-Identifier: Apache-2.0

@testset "utils" begin
    @test version_string() isa String
    print_version()
    say_hello()
    set_verbosity(0)   # returns nothing; just check these are callable
    @test to_string(Spinhalf(2)) isa String
    @test to_string(Permutation([1, 2])) isa String
end
