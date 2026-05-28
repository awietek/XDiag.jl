# SPDX-FileCopyrightText: 2025 Alexander Wietek <awietek@pks.mpg.de>
#
# SPDX-License-Identifier: Apache-2.0

struct COOMatrix{IdxT<:Integer,CoeffT<:Number}
    nrows::IdxT
    ncols::IdxT
    row::Vector{IdxT}
    col::Vector{IdxT} 
    data::Vector{CoeffT}
    i0::IdxT
    ishermitian::Bool
end

struct CSRMatrix{IdxT<:Integer,CoeffT<:Number}
    nrows::IdxT
    ncols::IdxT
    rowptr::Vector{IdxT}
    col::Vector{IdxT} 
    data::Vector{CoeffT}
    i0::IdxT
    ishermitian::Bool
end

struct CSCMatrix{IdxT<:Integer,CoeffT<:Number}
    nrows::IdxT
    ncols::IdxT
    colptr::Vector{IdxT} 
    row::Vector{IdxT}
    data::Vector{CoeffT}
    i0::IdxT
    ishermitian::Bool
end

function _cxx_create_csr_matrix(mat::CSRMatrix{Int64,Float64})
    return cxx_create_csr_matrix(mat.nrows, mat.ncols, Int64(size(mat.data, 1)),
                                 pointer(mat.rowptr), pointer(mat.col), pointer(mat.data),
                                 Int64(mat.i0), mat.ishermitian)
end

function _cxx_create_csr_matrix(mat::CSRMatrix{Int64,ComplexF64})
    return cxx_create_csr_matrix(mat.nrows, mat.ncols, Int64(size(mat.data, 1)),
                                 pointer(mat.rowptr), pointer(mat.col), pointer(mat.data),
                                 Int64(mat.i0), mat.ishermitian)
end

function _cxx_create_csr_matrix(mat::CSRMatrix{Int32,Float64})
    return cxx_create_csr_matrix(mat.nrows, mat.ncols, Int64(size(mat.data, 1)),
                                 pointer(mat.rowptr), pointer(mat.col), pointer(mat.data),
                                 Int32(mat.i0), mat.ishermitian)
end

function _cxx_create_csr_matrix(mat::CSRMatrix{Int32,ComplexF64})
    return cxx_create_csr_matrix(mat.nrows, mat.ncols, Int64(size(mat.data, 1)),
                                 pointer(mat.rowptr), pointer(mat.col), pointer(mat.data),
                                 Int32(mat.i0), mat.ishermitian)
end

function to_cxx_csr_matrix(mat::CSRMatrix)
    rowptr = mat.rowptr
    col = mat.col
    data = mat.data
    GC.@preserve mat rowptr col data begin
        return _cxx_create_csr_matrix(mat)
    end
end

function with_cxx_csr_matrix(f::F, mat::CSRMatrix) where F
    rowptr = mat.rowptr
    col = mat.col
    data = mat.data
    GC.@preserve mat rowptr col data begin
        return f(_cxx_create_csr_matrix(mat))
    end
end
