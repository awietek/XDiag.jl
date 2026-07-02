# SPDX-License-Identifier: Apache-2.0
# Hand-written specials: sparse matrices via the caller-allocated two-phase
# build (csr_matrix_nnz/csr_matrix_fill, coo_matrix_nnz/coo_matrix_fill).

struct CSRMatrix{IdxT<:Integer,CoeffT<:Number}
    nrows::IdxT
    ncols::IdxT
    rowptr::Vector{IdxT}
    col::Vector{IdxT}
    data::Vector{CoeffT}
    i0::IdxT
    ishermitian::Bool
end

struct COOMatrix{IdxT<:Integer,CoeffT<:Number}
    nrows::IdxT
    ncols::IdxT
    row::Vector{IdxT}
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

_isreal(ops, bin, bout) = isreal(ops) && isreal(bin) && isreal(bout)
# Matches the C++ builders, which set the flag from ishermitian(ops, block_in).
_isherm(ops, bin, bout) = cxx_ishermitian(ops.cxx_opsum, bin.cxx_block)

function _csr(ops, bin, bout, i0, ::Type{IdxT}) where {IdxT}
    real = _isreal(ops, bin, bout)
    CoeffT = real ? Float64 : ComplexF64
    nnzfn = real ? cxx_csr_matrix_nnz : cxx_csr_matrixC_nnz
    counts = nnzfn(ops.cxx_opsum, bin.cxx_block, bout.cxx_block)
    nnz = Int64(sum(counts))
    nrows = IdxT(size(bout)); ncols = IdxT(size(bin))
    rowptr = Vector{IdxT}(undef, nrows + 1)
    col = Vector{IdxT}(undef, nnz)
    data = Vector{CoeffT}(undef, nnz)
    fillfn = if IdxT == Int32
        real ? cxx_csr_matrix_32_fill : cxx_csr_matrixC_32_fill
    else
        real ? cxx_csr_matrix_fill : cxx_csr_matrixC_fill
    end
    GC.@preserve counts rowptr col data begin
        fillfn(ops.cxx_opsum, bin.cxx_block, bout.cxx_block, counts,
               pointer(rowptr), pointer(col), pointer(data), IdxT(i0))
    end
    return CSRMatrix{IdxT,CoeffT}(nrows, ncols, rowptr, col, data, IdxT(i0),
                                  _isherm(ops, bin, bout))
end

csr_matrix(ops::OpSum, bin::Block, bout::Block, i0::Int64=1) = _csr(ops, bin, bout, i0, Int64)
csr_matrix(ops::OpSum, b::B, i0::Int64=1) where {B<:Block} =
    csr_matrix(ops, b, B(cxx_block(ops.cxx_opsum, b.cxx_block)), i0)
csr_matrix_32(ops::OpSum, bin::Block, bout::Block, i0::Int64=1) = _csr(ops, bin, bout, i0, Int32)
csr_matrix_32(ops::OpSum, b::B, i0::Int64=1) where {B<:Block} =
    csr_matrix_32(ops, b, B(cxx_block(ops.cxx_opsum, b.cxx_block)), i0)

function _coo(ops, bin, bout, i0, ::Type{IdxT}) where {IdxT}
    real = _isreal(ops, bin, bout)
    CoeffT = real ? Float64 : ComplexF64
    nnzfn = real ? cxx_coo_matrix_nnz : cxx_coo_matrixC_nnz
    nnz = Int64(nnzfn(ops.cxx_opsum, bin.cxx_block, bout.cxx_block))
    row = Vector{IdxT}(undef, nnz); col = Vector{IdxT}(undef, nnz)
    data = Vector{CoeffT}(undef, nnz)
    fillfn = if IdxT == Int32
        real ? cxx_coo_matrix_32_fill : cxx_coo_matrixC_32_fill
    else
        real ? cxx_coo_matrix_fill : cxx_coo_matrixC_fill
    end
    GC.@preserve row col data begin
        fillfn(ops.cxx_opsum, bin.cxx_block, bout.cxx_block, nnz,
               pointer(row), pointer(col), pointer(data), IdxT(i0))
    end
    return COOMatrix{IdxT,CoeffT}(IdxT(size(bout)), IdxT(size(bin)), row, col,
                                  data, IdxT(i0), _isherm(ops, bin, bout))
end
coo_matrix(ops::OpSum, bin::Block, bout::Block, i0::Int64=1) = _coo(ops, bin, bout, i0, Int64)
coo_matrix(ops::OpSum, b::B, i0::Int64=1) where {B<:Block} =
    coo_matrix(ops, b, B(cxx_block(ops.cxx_opsum, b.cxx_block)), i0)
coo_matrix_32(ops::OpSum, bin::Block, bout::Block, i0::Int64=1) = _coo(ops, bin, bout, i0, Int32)
coo_matrix_32(ops::OpSum, b::B, i0::Int64=1) where {B<:Block} =
    coo_matrix_32(ops, b, B(cxx_block(ops.cxx_opsum, b.cxx_block)), i0)

# CSC is derived Julia-side from the CSR arrays (transpose of structure), per
# the library convention that CSC == transposed CSR.
function _csc(ops, bin, bout, i0, ::Type{IdxT}) where {IdxT}
    csr = _csr(ops, bin, bout, i0, IdxT)
    nrows, ncols, nnz = csr.nrows, csr.ncols, length(csr.data)
    colptr = zeros(IdxT, ncols + 1)
    row = Vector{IdxT}(undef, nnz)
    data = Vector{eltype(csr.data)}(undef, nnz)
    @inbounds for k in 1:nnz  # column counts (shifted into colptr[2:end])
        colptr[csr.col[k] - csr.i0 + 2] += 1
    end
    @inbounds for c in 1:ncols
        colptr[c + 1] += colptr[c]
    end
    next = copy(colptr)
    @inbounds for r in 1:nrows
        for k in (csr.rowptr[r] - csr.i0 + 1):(csr.rowptr[r + 1] - csr.i0)
            c = csr.col[k] - csr.i0 + 1
            pos = next[c] + 1
            row[pos] = IdxT(r - 1 + i0)
            data[pos] = csr.data[k]
            next[c] += 1
        end
    end
    colptr .+= IdxT(i0)
    return CSCMatrix{IdxT,eltype(data)}(nrows, ncols, colptr, row, data,
                                        IdxT(i0), csr.ishermitian)
end
csc_matrix(ops::OpSum, bin::Block, bout::Block, i0::Int64=1) = _csc(ops, bin, bout, i0, Int64)
csc_matrix(ops::OpSum, b::B, i0::Int64=1) where {B<:Block} =
    csc_matrix(ops, b, B(cxx_block(ops.cxx_opsum, b.cxx_block)), i0)
csc_matrix_32(ops::OpSum, bin::Block, bout::Block, i0::Int64=1) = _csc(ops, bin, bout, i0, Int32)
csc_matrix_32(ops::OpSum, b::B, i0::Int64=1) where {B<:Block} =
    csc_matrix_32(ops, b, B(cxx_block(ops.cxx_opsum, b.cxx_block)), i0)

function to_dense(m::CSRMatrix{IdxT,CoeffT}) where {IdxT,CoeffT}
    d = zeros(CoeffT, m.nrows, m.ncols)
    @inbounds for r in 1:m.nrows
        for k in (m.rowptr[r] - m.i0 + 1):(m.rowptr[r + 1] - m.i0)
            d[r, m.col[k] - m.i0 + 1] += m.data[k]
        end
    end
    return d
end
function to_dense(m::COOMatrix{IdxT,CoeffT}) where {IdxT,CoeffT}
    d = zeros(CoeffT, m.nrows, m.ncols)
    @inbounds for k in 1:length(m.data)
        d[m.row[k] - m.i0 + 1, m.col[k] - m.i0 + 1] += m.data[k]
    end
    return d
end
function to_dense(m::CSCMatrix{IdxT,CoeffT}) where {IdxT,CoeffT}
    d = zeros(CoeffT, m.nrows, m.ncols)
    @inbounds for c in 1:m.ncols
        for k in (m.colptr[c] - m.i0 + 1):(m.colptr[c + 1] - m.i0)
            d[m.row[k] - m.i0 + 1, c] += m.data[k]
        end
    end
    return d
end
