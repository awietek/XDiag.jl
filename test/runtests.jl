using XDiag
using Test

include("operators/coupling.jl")
include("operators/op.jl")
include("operators/opsum.jl")

include("states/state.jl")

# @testset "XDiag.jl" begin
#     N = 2
#     block = Spinhalf(N, N÷2)
#     bonds = Bond[]
#     for s in 1:N
#         bond =  Bond("HB", 1.0, [s,  mod1(s+1, N)])
#         push!(bonds, bond)
#     end
#     H = BondList(bonds)
#     mat = matrix(H, block)
#     @show mat
#     mat2 = [-.5 1; 1 -.5]
#     @test isapprox(mat, mat2)
    
#     e0 = eigval0(H, block)
#     @test isapprox(e0, -3.0/2.0)


#     N = 12
#     block = Spinhalf(N, N÷2)
#     bonds = Bond[]
#     for s in 1:N
#         bond =  Bond("HB", 1.0, [s,  mod1(s+1, N)])
#         push!(bonds, bond)
#     end
#     H = BondList(bonds)
#     e0 = eigval0(H, block)
#     @test isapprox(e0, -5.387390917444964)
    
# end
