# SPDX - FileCopyrightText : 2025 Alexander Wietek <awietek @pks.mpg.de>
#
# SPDX - License - Identifier : Apache - 2.0


####################
# apply with return 

# Vector
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


# Matrix
apply(mat::CSRMatrix{Int64, Float64}, v::Matrix{Float64}) =
    to_julia(cxx_apply(to_cxx_csr_matrix(mat),
                       to_armadillo(v; copy=false)))
apply(mat::CSRMatrix{Int64, ComplexF64}, v::Matrix{ComplexF64}) =
    to_julia(cxx_apply(to_cxx_csr_matrix(mat),
                       to_armadillo(v; copy=false)))
apply(mat::CSRMatrix{Int64, Float64}, v::Matrix{ComplexF64}) =
    to_julia(cxx_apply(to_cxx_csr_matrix(mat),
                       to_armadillo(v; copy=false)))

apply(mat::CSRMatrix{Int32, Float64}, v::Matrix{Float64}) =
    to_julia(cxx_apply(to_cxx_csr_matrix(mat),
                       to_armadillo(v; copy=false)))
apply(mat::CSRMatrix{Int32, ComplexF64}, v::Matrix{ComplexF64}) =
    to_julia(cxx_apply(to_cxx_csr_matrix(mat),
                       to_armadillo(v; copy=false)))
apply(mat::CSRMatrix{Int32, Float64}, v::Matrix{ComplexF64}) =
    to_julia(cxx_apply(to_cxx_csr_matrix(mat),
                       to_armadillo(v; copy=false)))


######################
# apply without return

# Vector
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


# Matrix
apply(mat::CSRMatrix{Int64, Float64}, v::Matrix{Float64}, w::Matrix{Float64}) =
    cxx_apply(to_cxx_csr_matrix(mat),
              to_armadillo(v; copy=false),
              to_armadillo(w; copy=false))

apply(mat::CSRMatrix{Int64, ComplexF64}, v::Matrix{ComplexF64}, w::Matrix{ComplexF64}) =
    cxx_apply(to_cxx_csr_matrix(mat),
              to_armadillo(v; copy=false),
              to_armadillo(w; copy=false))

apply(mat::CSRMatrix{Int64, Float64}, v::Matrix{ComplexF64}, w::Matrix{ComplexF64}) =
    cxx_apply(to_cxx_csr_matrix(mat),
              to_armadillo(v; copy=false),
              to_armadillo(w; copy=false))


apply(mat::CSRMatrix{Int32, Float64}, v::Matrix{Float64}, w::Matrix{Float64}) =
    cxx_apply(to_cxx_csr_matrix(mat),
              to_armadillo(v; copy=false),
              to_armadillo(w; copy=false))

apply(mat::CSRMatrix{Int32, ComplexF64}, v::Matrix{ComplexF64}, w::Matrix{ComplexF64}) =
    cxx_apply(to_cxx_csr_matrix(mat),
              to_armadillo(v; copy=false),
              to_armadillo(w; copy=false))

apply(mat::CSRMatrix{Int32, Float64}, v::Matrix{ComplexF64}, w::Matrix{ComplexF64}) =
    cxx_apply(to_cxx_csr_matrix(mat),
              to_armadillo(v; copy=false),
              to_armadillo(w; copy=false))
