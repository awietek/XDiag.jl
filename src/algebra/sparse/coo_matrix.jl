# SPDX-FileCopyrightText: 2025 Alexander Wietek <awietek@pks.mpg.de>
#
# SPDX-License-Identifier: Apache-2.0

function coo_matrix(ops::OpSum, block::B, i0::Int64=1) where B <: Block
    blockr = B(cxx_block(ops.cxx_opsum, block.cxx_block))
    return coo_matrix(ops, block, blockr, i0)
end


function coo_matrix_32(ops::OpSum, block::B, i0::Int64=1) where B <: Block
    blockr = B(cxx_block(ops.cxx_opsum, block.cxx_block))
    return coo_matrix_32(ops, block, blockr, i0)
end



function coo_matrix(ops::OpSum, block_in::Block, block_out::Block, i0::Int64=1)

    # Real version
    if isreal(ops) && isreal(block_in) && isreal(block_out)
        nrows = size(block_out)
        ncols = size(block_in)
        if ((nrows == 0) || (ncols == 0))
            return COOMatrix{Int64, Float64}()
        end

        # compute the number of nonzero elements
        nnz_thread = cxx_coo_matrix_nnz_thread(ops.cxx_opsum,
                                               block_in.cxx_block,
                                               block_out.cxx_block)
        nnz = sum(nnz_thread)

        # Allocate vectors on julia side
        row = Vector{Int64}(undef, nnz)
        col = Vector{Int64}(undef, nnz)
        data = Vector{Float64}(undef, nnz)

        # compute the matrix
        GC.@preserve nnz_thread row col data begin
            cxx_coo_matrix_fill(ops.cxx_opsum, block_in.cxx_block, block_out.cxx_block,
                                nnz_thread, nnz,
                                pointer(row), pointer(col), pointer(data),
                                i0)
        end
        nrows = Int64(size(block_out))
        ncols = Int64(size(block_in))    
        isherm = cxx_ishermitian(ops.cxx_opsum)
        return COOMatrix(nrows, ncols, row, col, data, i0, isherm)

    # complex version
    else
        nrows = size(block_out)
        ncols = size(block_in)
        if ((nrows == 0) || (ncols == 0))
            return COOMatrix{Int64, ComplexF64}()
        end
        
        # compute the number of nonzero elements
        nnz_thread = cxx_coo_matrix_nnz_threadC(ops.cxx_opsum,
                                                block_in.cxx_block,
                                                block_out.cxx_block)
        nnz = sum(nnz_thread)

        # Allocate vectors on julia side
        row = Vector{Int64}(undef, nnz)
        col = Vector{Int64}(undef, nnz)
        data = Vector{ComplexF64}(undef, nnz)

        # compute the matrix
        GC.@preserve nnz_thread row col data begin
            cxx_coo_matrix_fill(ops.cxx_opsum, block_in.cxx_block, block_out.cxx_block,
                                nnz_thread, nnz,
                                pointer(row), pointer(col), pointer(data),
                                i0)
        end
        nrows = Int64(size(block_out))
        ncols = Int64(size(block_in))    
        isherm = cxx_ishermitian(ops.cxx_opsum)
        return COOMatrix(nrows, ncols, row, col, data, i0, isherm)
    end
end

function coo_matrix_32(ops::OpSum, block_in::Block, block_out::Block, i0::Int64=1)

    # Real version
    if isreal(ops) && isreal(block_in) && isreal(block_out)

        nrows = size(block_out)
        ncols = size(block_in)
        if ((nrows == 0) || (ncols == 0))
            return COOMatrix{Int32, Float64}()
        end


        # compute the number of nonzero elements
        nnz_thread = cxx_coo_matrix_nnz_thread(ops.cxx_opsum,
                                               block_in.cxx_block,
                                               block_out.cxx_block)
        nnz = sum(nnz_thread)

        # Allocate vectors on julia side
        row = Vector{Int32}(undef, nnz)
        col = Vector{Int32}(undef, nnz)
        data = Vector{Float64}(undef, nnz)

        # compute the matrix
        GC.@preserve nnz_thread row col data begin
            cxx_coo_matrix_fill(ops.cxx_opsum, block_in.cxx_block, block_out.cxx_block,
                                nnz_thread, nnz,
                                pointer(row), pointer(col), pointer(data),
                                Int32(i0))
        end
        nrows = Int32(size(block_out))
        ncols = Int32(size(block_in))    
        isherm = cxx_ishermitian(ops.cxx_opsum)
        return COOMatrix(nrows, ncols, row, col, data, Int32(i0), isherm)

    # complex version
    else 
        nrows = size(block_out)
        ncols = size(block_in)
        if ((nrows == 0) || (ncols == 0))
            return COOMatrix{Int32, ComplexF64}()
        end

        # compute the number of nonzero elements
        nnz_thread = cxx_coo_matrix_nnz_threadC(ops.cxx_opsum,
                                                block_in.cxx_block,
                                                block_out.cxx_block)
        nnz = sum(nnz_thread)

        # Allocate vectors on julia side
        row = Vector{Int32}(undef, nnz)
        col = Vector{Int32}(undef, nnz)
        data = Vector{ComplexF64}(undef, nnz)

        # compute the matrix
        GC.@preserve nnz_thread row col data begin
            cxx_coo_matrix_fill(ops.cxx_opsum, block_in.cxx_block, block_out.cxx_block,
                                nnz_thread, nnz,
                                pointer(row), pointer(col), pointer(data),
                                Int32(i0))
        end
        nrows = Int32(size(block_out))
        ncols = Int32(size(block_in))    
        isherm = cxx_ishermitian(ops.cxx_opsum)
        return COOMatrix(nrows, ncols, row, col, data, Int32(i0), isherm)

    end
end

function to_dense(mat::COOMatrix{Int64, Float64})
    row = mat.row
    col = mat.col
    data = mat.data
    GC.@preserve mat row col data begin
        cxx_spmat = cxx_create_coo_matrix(mat.nrows,
                                          mat.ncols,
                                          Int64(size(data, 1)),
                                          pointer(row), pointer(col), pointer(data),
                                          Int64(mat.i0),
                                          mat.ishermitian)
        return to_julia(cxx_to_dense(cxx_spmat))
    end
end

function to_dense(mat::COOMatrix{Int64, ComplexF64})
    row = mat.row
    col = mat.col
    data = mat.data
    GC.@preserve mat row col data begin
        cxx_spmat = cxx_create_coo_matrix(mat.nrows,
                                          mat.ncols,
                                          Int64(size(data, 1)),
                                          pointer(row), pointer(col), pointer(data),
                                          Int64(mat.i0),
                                          mat.ishermitian)
        return to_julia(cxx_to_dense(cxx_spmat))
    end
end

function to_dense(mat::COOMatrix{Int32, Float64})
    row = mat.row
    col = mat.col
    data = mat.data
    GC.@preserve mat row col data begin
        cxx_spmat = cxx_create_coo_matrix(mat.nrows,
                                          mat.ncols,
                                          Int64(size(data, 1)),
                                          pointer(row), pointer(col), pointer(data),
                                          Int32(mat.i0),
                                          mat.ishermitian)
        return to_julia(cxx_to_dense(cxx_spmat))
    end
end

function to_dense(mat::COOMatrix{Int32, ComplexF64})
    row = mat.row
    col = mat.col
    data = mat.data
    GC.@preserve mat row col data begin
        cxx_spmat = cxx_create_coo_matrix(mat.nrows,
                                          mat.ncols,
                                          Int64(size(data, 1)),
                                          pointer(row), pointer(col), pointer(data),
                                          Int32(mat.i0),
                                          mat.ishermitian)
        return to_julia(cxx_to_dense(cxx_spmat))
    end
end
