# SPDX-FileCopyrightText: 2025 Alexander Wietek <awietek@pks.mpg.de>
#
# SPDX-License-Identifier: Apache-2.0

function csc_matrix(ops::OpSum, block::B, i0::Int64=1) where B <: Block
    blockr = B(cxx_block(ops.cxx_opsum, block.cxx_block))
    return csc_matrix(ops, block, blockr, i0)
end

function csc_matrixC(ops::OpSum, block::B, i0::Int64=1) where B <: Block
    blockr = B(cxx_block(ops.cxx_opsum, block.cxx_block))
    return csc_matrixC(ops, block, blockr, i0)
end

function csc_matrix_32(ops::OpSum, block::B, i0::Int64=1) where B <: Block
    blockr = B(cxx_block(ops.cxx_opsum, block.cxx_block))
    return csc_matrix_32(ops, block, blockr, i0)
end

function csc_matrixC_32(ops::OpSum, block::B, i0::Int64=1) where B <: Block
    blockr = B(cxx_block(ops.cxx_opsum, block.cxx_block))
    return csc_matrixC_32(ops, block, blockr, i0)
end

function csc_matrix(ops::OpSum, block_in::Block, block_out::Block, i0::Int64=1)
    nrows = size(block_out)
    ncols = size(block_in)
    if ((nrows == 0) || (ncols == 0))
        return CSCMatrix{Int64, Float64}()
    end

    # compute the number of nonzero elements
    n_elements_in_col = cxx_csr_matrix_nnz(ops.cxx_opsum,
                                           block_in.cxx_block,
                                           block_out.cxx_block,
                                           true)
    nnz = sum(n_elements_in_col)

    # Allocate vectors on julia side
    colptr = Vector{Int64}(undef, size(n_elements_in_col)[1]+1)
    row = Vector{Int64}(undef, nnz)
    data = Vector{Float64}(undef, nnz)

    # compute the matrix
    cxx_csr_matrix_fill(ops.cxx_opsum, block_in.cxx_block, block_out.cxx_block,
                        nnz, n_elements_in_col,
                        Base.unsafe_convert(Ptr{Int64}, colptr),
                        Base.unsafe_convert(Ptr{Int64}, row),
                        Base.unsafe_convert(Ptr{Float64}, data),
                        i0, true)
    nrows = Int64(size(block_out))
    ncols = Int64(size(block_in))    
    isherm = cxx_ishermitian(ops.cxx_opsum)
    return CSCMatrix(nrows, ncols, colptr, row, data, i0, isherm)
end

function csc_matrixC(ops::OpSum, block_in::Block, block_out::Block, i0::Int64=1)
    nrows = size(block_out)
    ncols = size(block_in)
    if ((nrows == 0) || (ncols == 0))
        return CSCMatrix{Int64, ComplexF64}()
    end

    # compute the number of nonzero elements
    n_elements_in_col = cxx_csr_matrixC_nnz(ops.cxx_opsum,
                                            block_in.cxx_block,
                                            block_out.cxx_block,
                                            true)
    nnz = sum(n_elements_in_col)

    # Allocate vectors on julia side
    colptr = Vector{Int64}(undef, size(n_elements_in_col)[1]+1)
    row = Vector{Int64}(undef, nnz)
    data = Vector{ComplexF64}(undef, nnz)

    # compute the matrix
    cxx_csr_matrix_fill(ops.cxx_opsum, block_in.cxx_block, block_out.cxx_block,
                        nnz, n_elements_in_col,
                        Base.unsafe_convert(Ptr{Int64}, colptr),
                        Base.unsafe_convert(Ptr{Int64}, row),
                        Base.unsafe_convert(Ptr{ComplexF64}, data),
                        i0, true)
    nrows = Int64(size(block_out))
    ncols = Int64(size(block_in))    
    isherm = cxx_ishermitian(ops.cxx_opsum)
    return CSCMatrix(nrows, ncols, colptr, row, data, i0, isherm)
end

function csc_matrix_32(ops::OpSum, block_in::Block, block_out::Block, i0::Int64=1)
    nrows = size(block_out)
    ncols = size(block_in)
    if ((nrows == 0) || (ncols == 0))
        return CSCMatrix{Int32, Float64}()
    end

    # compute the number of nonzero elements
    n_elements_in_col = cxx_csr_matrix_32_nnz(ops.cxx_opsum,
                                              block_in.cxx_block,
                                              block_out.cxx_block,
                                              true)
    nnz = sum(n_elements_in_col)

    # Allocate vectors on julia side
    colptr = Vector{Int32}(undef, size(n_elements_in_col)[1]+1)
    row = Vector{Int32}(undef, nnz)
    data = Vector{Float64}(undef, nnz)

    # compute the matrix
    cxx_csr_matrix_fill(ops.cxx_opsum, block_in.cxx_block, block_out.cxx_block,
                        nnz, n_elements_in_col,
                        Base.unsafe_convert(Ptr{Int32}, colptr),
                        Base.unsafe_convert(Ptr{Int32}, row),
                        Base.unsafe_convert(Ptr{Float64}, data),
                        Int32(i0), true)
    nrows = Int32(size(block_out))
    ncols = Int32(size(block_in))    
    isherm = cxx_ishermitian(ops.cxx_opsum)
    return CSCMatrix(nrows, ncols, colptr, row, data, Int32(i0), isherm)
end

function csc_matrixC_32(ops::OpSum, block_in::Block, block_out::Block, i0::Int64=1)
    nrows = size(block_out)
    ncols = size(block_in)
    if ((nrows == 0) || (ncols == 0))
        return CSCMatrix{Int32, ComplexF64}()
    end

    # compute the number of nonzero elements
    n_elements_in_col = cxx_csr_matrixC_32_nnz(ops.cxx_opsum,
                                               block_in.cxx_block,
                                               block_out.cxx_block,
                                               true)
    nnz = sum(n_elements_in_col)

    # Allocate vectors on julia side
    colptr = Vector{Int32}(undef, size(n_elements_in_col)[1]+1)
    row = Vector{Int32}(undef, nnz)
    data = Vector{ComplexF64}(undef, nnz)

    # compute the matrix
    cxx_csr_matrix_fill(ops.cxx_opsum, block_in.cxx_block, block_out.cxx_block,
                        nnz, n_elements_in_col,
                        Base.unsafe_convert(Ptr{Int32}, colptr),
                        Base.unsafe_convert(Ptr{Int32}, row),
                        Base.unsafe_convert(Ptr{ComplexF64}, data),
                        Int32(i0), true)
    nrows = Int32(size(block_out))
    ncols = Int32(size(block_in))    
    isherm = cxx_ishermitian(ops.cxx_opsum)
    return CSCMatrix(nrows, ncols, colptr, row, data, Int32(i0), isherm)
end

function to_dense(mat::CSCMatrix{Int64, Float64})
    cxx_spmat = cxx_create_csc_matrix(mat.nrows,
                                      mat.ncols,
                                      Int64(size(mat.data, 1)),
                                      Base.unsafe_convert(Ptr{Int64}, mat.colptr),
                                      Base.unsafe_convert(Ptr{Int64}, mat.row),
                                      Base.unsafe_convert(Ptr{Float64}, mat.data),
                                      Int64(mat.i0),
                                      mat.ishermitian)
    return to_julia(cxx_to_dense(cxx_spmat))
end

function to_dense(mat::CSCMatrix{Int64, ComplexF64})
    cxx_spmat = cxx_create_csc_matrix(mat.nrows,
                                      mat.ncols,
                                      Int64(size(mat.data, 1)),
                                      Base.unsafe_convert(Ptr{Int64}, mat.colptr),
                                      Base.unsafe_convert(Ptr{Int64}, mat.row),
                                      Base.unsafe_convert(Ptr{ComplexF64}, mat.data),
                                      Int64(mat.i0),
                                      mat.ishermitian)
    return to_julia(cxx_to_dense(cxx_spmat))
end

function to_dense(mat::CSCMatrix{Int32, Float64})
    cxx_spmat = cxx_create_csc_matrix(mat.nrows,
                                      mat.ncols,
                                      Int64(size(mat.data, 1)),
                                      Base.unsafe_convert(Ptr{Int32}, mat.colptr),
                                      Base.unsafe_convert(Ptr{Int32}, mat.row),
                                      Base.unsafe_convert(Ptr{Float64}, mat.data),
                                      Int32(mat.i0),
                                      mat.ishermitian)
    return to_julia(cxx_to_dense(cxx_spmat))
end

function to_dense(mat::CSCMatrix{Int32, ComplexF64})
    cxx_spmat = cxx_create_csc_matrix(mat.nrows,
                                      mat.ncols,
                                      Int64(size(mat.data, 1)),
                                      Base.unsafe_convert(Ptr{Int32}, mat.colptr),
                                      Base.unsafe_convert(Ptr{Int32}, mat.row),
                                      Base.unsafe_convert(Ptr{ComplexF64}, mat.data),
                                      Int32(mat.i0),
                                      mat.ishermitian)
    return to_julia(cxx_to_dense(cxx_spmat))
end

