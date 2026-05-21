# SPDX - FileCopyrightText : 2025 Alexander Wietek <awietek @pks.mpg.de>
#
# SPDX - License - Identifier : Apache - 2.0


####################
# apply with return 

# Vector
apply(mat::CSRMatrix{Int64, Float64}, v::Vector{Float64}) =
    with_cxx_csr_matrix(mat) do cxx_mat
        with_armadillo(v; copy=false) do v_arma
            return to_julia(cxx_apply(cxx_mat, v_arma))
        end
    end
apply(mat::CSRMatrix{Int64, ComplexF64}, v::Vector{ComplexF64}) =
    with_cxx_csr_matrix(mat) do cxx_mat
        with_armadillo(v; copy=false) do v_arma
            return to_julia(cxx_apply(cxx_mat, v_arma))
        end
    end
apply(mat::CSRMatrix{Int64, Float64}, v::Vector{ComplexF64}) =
    with_cxx_csr_matrix(mat) do cxx_mat
        with_armadillo(v; copy=false) do v_arma
            return to_julia(cxx_apply(cxx_mat, v_arma))
        end
    end

apply(mat::CSRMatrix{Int32, Float64}, v::Vector{Float64}) =
    with_cxx_csr_matrix(mat) do cxx_mat
        with_armadillo(v; copy=false) do v_arma
            return to_julia(cxx_apply(cxx_mat, v_arma))
        end
    end
apply(mat::CSRMatrix{Int32, ComplexF64}, v::Vector{ComplexF64}) =
    with_cxx_csr_matrix(mat) do cxx_mat
        with_armadillo(v; copy=false) do v_arma
            return to_julia(cxx_apply(cxx_mat, v_arma))
        end
    end
apply(mat::CSRMatrix{Int32, Float64}, v::Vector{ComplexF64}) =
    with_cxx_csr_matrix(mat) do cxx_mat
        with_armadillo(v; copy=false) do v_arma
            return to_julia(cxx_apply(cxx_mat, v_arma))
        end
    end


# Matrix
apply(mat::CSRMatrix{Int64, Float64}, v::Matrix{Float64}) =
    with_cxx_csr_matrix(mat) do cxx_mat
        with_armadillo(v; copy=false) do v_arma
            return to_julia(cxx_apply(cxx_mat, v_arma))
        end
    end
apply(mat::CSRMatrix{Int64, ComplexF64}, v::Matrix{ComplexF64}) =
    with_cxx_csr_matrix(mat) do cxx_mat
        with_armadillo(v; copy=false) do v_arma
            return to_julia(cxx_apply(cxx_mat, v_arma))
        end
    end
apply(mat::CSRMatrix{Int64, Float64}, v::Matrix{ComplexF64}) =
    with_cxx_csr_matrix(mat) do cxx_mat
        with_armadillo(v; copy=false) do v_arma
            return to_julia(cxx_apply(cxx_mat, v_arma))
        end
    end

apply(mat::CSRMatrix{Int32, Float64}, v::Matrix{Float64}) =
    with_cxx_csr_matrix(mat) do cxx_mat
        with_armadillo(v; copy=false) do v_arma
            return to_julia(cxx_apply(cxx_mat, v_arma))
        end
    end
apply(mat::CSRMatrix{Int32, ComplexF64}, v::Matrix{ComplexF64}) =
    with_cxx_csr_matrix(mat) do cxx_mat
        with_armadillo(v; copy=false) do v_arma
            return to_julia(cxx_apply(cxx_mat, v_arma))
        end
    end
apply(mat::CSRMatrix{Int32, Float64}, v::Matrix{ComplexF64}) =
    with_cxx_csr_matrix(mat) do cxx_mat
        with_armadillo(v; copy=false) do v_arma
            return to_julia(cxx_apply(cxx_mat, v_arma))
        end
    end


######################
# apply without return

# Vector
apply(mat::CSRMatrix{Int64, Float64}, v::Vector{Float64}, w::Vector{Float64}) =
    with_cxx_csr_matrix(mat) do cxx_mat
        with_armadillo(v; copy=false) do v_arma
            with_armadillo(w; copy=false) do w_arma
                return cxx_apply(cxx_mat, v_arma, w_arma)
            end
        end
    end

apply(mat::CSRMatrix{Int64, ComplexF64}, v::Vector{ComplexF64}, w::Vector{ComplexF64}) =
    with_cxx_csr_matrix(mat) do cxx_mat
        with_armadillo(v; copy=false) do v_arma
            with_armadillo(w; copy=false) do w_arma
                return cxx_apply(cxx_mat, v_arma, w_arma)
            end
        end
    end

apply(mat::CSRMatrix{Int64, Float64}, v::Vector{ComplexF64}, w::Vector{ComplexF64}) =
    with_cxx_csr_matrix(mat) do cxx_mat
        with_armadillo(v; copy=false) do v_arma
            with_armadillo(w; copy=false) do w_arma
                return cxx_apply(cxx_mat, v_arma, w_arma)
            end
        end
    end


apply(mat::CSRMatrix{Int32, Float64}, v::Vector{Float64}, w::Vector{Float64}) =
    with_cxx_csr_matrix(mat) do cxx_mat
        with_armadillo(v; copy=false) do v_arma
            with_armadillo(w; copy=false) do w_arma
                return cxx_apply(cxx_mat, v_arma, w_arma)
            end
        end
    end

apply(mat::CSRMatrix{Int32, ComplexF64}, v::Vector{ComplexF64}, w::Vector{ComplexF64}) =
    with_cxx_csr_matrix(mat) do cxx_mat
        with_armadillo(v; copy=false) do v_arma
            with_armadillo(w; copy=false) do w_arma
                return cxx_apply(cxx_mat, v_arma, w_arma)
            end
        end
    end

apply(mat::CSRMatrix{Int32, Float64}, v::Vector{ComplexF64}, w::Vector{ComplexF64}) =
    with_cxx_csr_matrix(mat) do cxx_mat
        with_armadillo(v; copy=false) do v_arma
            with_armadillo(w; copy=false) do w_arma
                return cxx_apply(cxx_mat, v_arma, w_arma)
            end
        end
    end


# Matrix
apply(mat::CSRMatrix{Int64, Float64}, v::Matrix{Float64}, w::Matrix{Float64}) =
    with_cxx_csr_matrix(mat) do cxx_mat
        with_armadillo(v; copy=false) do v_arma
            with_armadillo(w; copy=false) do w_arma
                return cxx_apply(cxx_mat, v_arma, w_arma)
            end
        end
    end

apply(mat::CSRMatrix{Int64, ComplexF64}, v::Matrix{ComplexF64}, w::Matrix{ComplexF64}) =
    with_cxx_csr_matrix(mat) do cxx_mat
        with_armadillo(v; copy=false) do v_arma
            with_armadillo(w; copy=false) do w_arma
                return cxx_apply(cxx_mat, v_arma, w_arma)
            end
        end
    end

apply(mat::CSRMatrix{Int64, Float64}, v::Matrix{ComplexF64}, w::Matrix{ComplexF64}) =
    with_cxx_csr_matrix(mat) do cxx_mat
        with_armadillo(v; copy=false) do v_arma
            with_armadillo(w; copy=false) do w_arma
                return cxx_apply(cxx_mat, v_arma, w_arma)
            end
        end
    end


apply(mat::CSRMatrix{Int32, Float64}, v::Matrix{Float64}, w::Matrix{Float64}) =
    with_cxx_csr_matrix(mat) do cxx_mat
        with_armadillo(v; copy=false) do v_arma
            with_armadillo(w; copy=false) do w_arma
                return cxx_apply(cxx_mat, v_arma, w_arma)
            end
        end
    end

apply(mat::CSRMatrix{Int32, ComplexF64}, v::Matrix{ComplexF64}, w::Matrix{ComplexF64}) =
    with_cxx_csr_matrix(mat) do cxx_mat
        with_armadillo(v; copy=false) do v_arma
            with_armadillo(w; copy=false) do w_arma
                return cxx_apply(cxx_mat, v_arma, w_arma)
            end
        end
    end

apply(mat::CSRMatrix{Int32, Float64}, v::Matrix{ComplexF64}, w::Matrix{ComplexF64}) =
    with_cxx_csr_matrix(mat) do cxx_mat
        with_armadillo(v; copy=false) do v_arma
            with_armadillo(w; copy=false) do w_arma
                return cxx_apply(cxx_mat, v_arma, w_arma)
            end
        end
    end
