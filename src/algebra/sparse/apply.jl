# SPDX - FileCopyrightText : 2025 Alexander Wietek <awietek @pks.mpg.de>
#
# SPDX - License - Identifier : Apache - 2.0

# apply with return 
apply(mat::CSRMatrix{Int64, Float64}, v::Vector{Float64}) =
    to_julia(cxx_apply(to_cxx_csr_matrix(mat),
                       to_armadillo(v; copy=false)))
apply(mat::CSRMatrix{Int64, ComplexF64}, v::Vector{ComplexF64}) =
    to_julia(cxx_apply(to_cxx_csr_matrix(mat),
                       to_armadillo(v; copy=false)))
apply(mat::CSRMatrix{Int64, Float64}, v::Vector{ComplexF64}) =
    to_julia(cxx_apply(to_cxx_csr_matrix(mat),
                       to_armadillo(v; copy=false)))

apply(mat::CSRMatrix{Int32, Float64}, v::Vector{Float64}) =
    to_julia(cxx_apply(to_cxx_csr_matrix(mat),
                       to_armadillo(v; copy=false)))
apply(mat::CSRMatrix{Int32, ComplexF64}, v::Vector{ComplexF64}) =
    to_julia(cxx_apply(to_cxx_csr_matrix(mat),
                       to_armadillo(v; copy=false)))
apply(mat::CSRMatrix{Int32, Float64}, v::Vector{ComplexF64}) =
    to_julia(cxx_apply(to_cxx_csr_matrix(mat),
                       to_armadillo(v; copy=false)))


# apply without return
apply(mat::CSRMatrix{Int64, Float64}, v::Vector{Float64}, w::Vector{Float64}) =
    cxx_apply(to_cxx_csr_matrix(mat),
              to_armadillo(v; copy=false),
              to_armadillo(w; copy=false))

apply(mat::CSRMatrix{Int64, ComplexF64}, v::Vector{ComplexF64}, w::Vector{ComplexF64}) =
    cxx_apply(to_cxx_csr_matrix(mat),
              to_armadillo(v; copy=false),
              to_armadillo(w; copy=false))

apply(mat::CSRMatrix{Int64, Float64}, v::Vector{ComplexF64}, w::Vector{ComplexF64}) =
    cxx_apply(to_cxx_csr_matrix(mat),
              to_armadillo(v; copy=false),
              to_armadillo(w; copy=false))


apply(mat::CSRMatrix{Int32, Float64}, v::Vector{Float64}, w::Vector{Float64}) =
    cxx_apply(to_cxx_csr_matrix(mat),
              to_armadillo(v; copy=false),
              to_armadillo(w; copy=false))

apply(mat::CSRMatrix{Int32, ComplexF64}, v::Vector{ComplexF64}, w::Vector{ComplexF64}) =
    cxx_apply(to_cxx_csr_matrix(mat),
              to_armadillo(v; copy=false),
              to_armadillo(w; copy=false))

apply(mat::CSRMatrix{Int32, Float64}, v::Vector{ComplexF64}, w::Vector{ComplexF64}) =
    cxx_apply(to_cxx_csr_matrix(mat),
              to_armadillo(v; copy=false),
              to_armadillo(w; copy=false))
