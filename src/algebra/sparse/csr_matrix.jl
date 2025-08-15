# SPDX-FileCopyrightText: 2025 Alexander Wietek <awietek@pks.mpg.de>
#
# SPDX-License-Identifier: Apache-2.0

function csr_matrix(ops::OpSum, block::B, i0::Int64=1) where B <: Block
    blockr = B(cxx_block(ops.cxx_opsum, block.cxx_block))
    return csr_matrix(ops, block, blockr, i0)
end

function csr_matrix_32(ops::OpSum, block::B, i0::Int64=1) where B <: Block
    blockr = B(cxx_block(ops.cxx_opsum, block.cxx_block))
    return csr_matrix_32(ops, block, blockr, i0)
end

function csr_matrix(ops::OpSum, block_in::Block, block_out::Block, i0::Int64=1)
    # Real version
    if isreal(ops) && isreal(block_in) && isreal(block_out)
        nrows = size(block_out)
        ncols = size(block_in)
        if ((nrows == 0) || (ncols == 0))
            return CSRMatrix{Int64, Float64}()
        end

        # compute the number of nonzero elements
        n_elements_in_row = cxx_csr_matrix_nnz(ops.cxx_opsum,
                                               block_in.cxx_block,
                                               block_out.cxx_block,
                                               false)
        nnz = sum(n_elements_in_row)

        # Allocate vectors on julia side
        rowptr = Vector{Int64}(undef, size(n_elements_in_row)[1]+1)
        col = Vector{Int64}(undef, nnz)
        data = Vector{Float64}(undef, nnz)

        # compute the matrix
        cxx_csr_matrix_fill(ops.cxx_opsum, block_in.cxx_block, block_out.cxx_block,
                            nnz, n_elements_in_row,
                            Base.unsafe_convert(Ptr{Int64}, rowptr),
                            Base.unsafe_convert(Ptr{Int64}, col),
                            Base.unsafe_convert(Ptr{Float64}, data),
                            i0, false)
        nrows = Int64(size(block_out))
        ncols = Int64(size(block_in))    
        isherm = cxx_ishermitian(ops.cxx_opsum)
        return CSRMatrix(nrows, ncols, rowptr, col, data, i0, isherm)

    # complex version
    else
        nrows = size(block_out)
        ncols = size(block_in)
        if ((nrows == 0) || (ncols == 0))
            return CSRMatrix{Int64, ComplexF64}()
        end

        # compute the number of nonzero elements
        n_elements_in_row = cxx_csr_matrixC_nnz(ops.cxx_opsum,
                                                block_in.cxx_block,
                                                block_out.cxx_block,
                                                false)
        nnz = sum(n_elements_in_row)

        # Allocate vectors on julia side
        rowptr = Vector{Int64}(undef, size(n_elements_in_row)[1]+1)
        col = Vector{Int64}(undef, nnz)
        data = Vector{ComplexF64}(undef, nnz)

        # compute the matrix
        cxx_csr_matrix_fill(ops.cxx_opsum, block_in.cxx_block, block_out.cxx_block,
                            nnz, n_elements_in_row,
                            Base.unsafe_convert(Ptr{Int64}, rowptr),
                            Base.unsafe_convert(Ptr{Int64}, col),
                            Base.unsafe_convert(Ptr{ComplexF64}, data),
                            i0, false)
        nrows = Int64(size(block_out))
        ncols = Int64(size(block_in))    
        isherm = cxx_ishermitian(ops.cxx_opsum)
        return CSRMatrix(nrows, ncols, rowptr, col, data, i0, isherm)
    end
end


function csr_matrix_32(ops::OpSum, block_in::Block, block_out::Block, i0::Int64=1)
    # Real version
    if isreal(ops) && isreal(block_in) && isreal(block_out)

        nrows = size(block_out)
        ncols = size(block_in)
        if ((nrows == 0) || (ncols == 0))
            return CSRMatrix{Int32, Float64}()
        end

        # compute the number of nonzero elements
        n_elements_in_row = cxx_csr_matrix_32_nnz(ops.cxx_opsum,
                                                  block_in.cxx_block,
                                                  block_out.cxx_block,
                                                  false)
        nnz = sum(n_elements_in_row)

        # Allocate vectors on julia side
        rowptr = Vector{Int32}(undef, size(n_elements_in_row)[1]+1)
        col = Vector{Int32}(undef, nnz)
        data = Vector{Float64}(undef, nnz)

        # compute the matrix
        cxx_csr_matrix_fill(ops.cxx_opsum, block_in.cxx_block, block_out.cxx_block,
                            nnz, n_elements_in_row,
                            Base.unsafe_convert(Ptr{Int32}, rowptr),
                            Base.unsafe_convert(Ptr{Int32}, col),
                            Base.unsafe_convert(Ptr{Float64}, data),
                            Int32(i0), false)
        nrows = Int32(size(block_out))
        ncols = Int32(size(block_in))    
        isherm = cxx_ishermitian(ops.cxx_opsum)
        return CSRMatrix(nrows, ncols, rowptr, col, data, Int32(i0), isherm)

    # complex version
    else
        nrows = size(block_out)
        ncols = size(block_in)
        if ((nrows == 0) || (ncols == 0))
            return CSRMatrix{Int32, ComplexF64}()
        end

        # compute the number of nonzero elements
        n_elements_in_row = cxx_csr_matrixC_32_nnz(ops.cxx_opsum,
                                                   block_in.cxx_block,
                                                   block_out.cxx_block,
                                                   false)
        nnz = sum(n_elements_in_row)

        # Allocate vectors on julia side
        rowptr = Vector{Int32}(undef, size(n_elements_in_row)[1]+1)
        col = Vector{Int32}(undef, nnz)
        data = Vector{ComplexF64}(undef, nnz)

        # compute the matrix
        cxx_csr_matrix_fill(ops.cxx_opsum, block_in.cxx_block, block_out.cxx_block,
                            nnz, n_elements_in_row,
                            Base.unsafe_convert(Ptr{Int32}, rowptr),
                            Base.unsafe_convert(Ptr{Int32}, col),
                            Base.unsafe_convert(Ptr{ComplexF64}, data),
                            Int32(i0), false)
        nrows = Int32(size(block_out))
        ncols = Int32(size(block_in))    
        isherm = cxx_ishermitian(ops.cxx_opsum)
        return CSRMatrix(nrows, ncols, rowptr, col, data, Int32(i0), isherm)
    end
end

function to_dense(mat::CSRMatrix{Int64, Float64})
    cxx_spmat = to_cxx_csr_matrix(mat)
    return to_julia(cxx_to_dense(cxx_spmat))
end

function to_dense(mat::CSRMatrix{Int64, ComplexF64})
    cxx_spmat = to_cxx_csr_matrix(mat)
    return to_julia(cxx_to_dense(cxx_spmat))
end

function to_dense(mat::CSRMatrix{Int32, Float64})
    cxx_spmat = to_cxx_csr_matrix(mat)
    return to_julia(cxx_to_dense(cxx_spmat))
end

function to_dense(mat::CSRMatrix{Int32, ComplexF64})
    cxx_spmat = to_cxx_csr_matrix(mat)
    return to_julia(cxx_to_dense(cxx_spmat))
end
