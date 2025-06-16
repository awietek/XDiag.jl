# SPDX-FileCopyrightText: 2025 Alexander Wietek <awietek@pks.mpg.de>
#
# SPDX-License-Identifier: Apache-2.0

struct tJ <: Block
    cxx_block::cxx_tJ
end
convert(::Type{T}, block::cxx_tJ) where T <: tJ = tJ(block)

# Constructors
tJ() = tJ(construct_tJ())
tJ(nsites::Int64, nup::Int64, ndn::Int64, backend::String="auto") =
    tJ(construct_tJ(nsites, nup, ndn, backend))
tJ(nsites::Int64, nup::Int64, ndn::Int64, irrep::Representation, backend::String="auto") =
    tJ(construct_tJ(nsites, nup, ndn, irrep.cxx_representation, backend))

# Methods
nsites(block::tJ)::Int64 = nsites(block.cxx_block)
index(block::tJ, pstate::ProductState)::Int64 =
    index(block.cxx_block, pstate.cxx_product_state) + 1
Base.isreal(block::tJ)::Bool = isreal(block.cxx_block)
dim(block::tJ)::Int64 = dim(block.cxx_block)
Base.size(block::tJ)::Int64 = size(block.cxx_block)

# Iterators
function Base.iterate(block::tJ)
    if size(block) > 0
        b = _begin(block.cxx_block)
        return ProductState(_deref(b)), b
    else
        return nothing
    end
end

function Base.iterate(block::tJ, state)
    _incr(state)
    if state != _end(block.cxx_block)
        return ProductState(_deref(state)), state
    else
        return nothing
    end
end

# Output
to_string(block::tJ)::String = to_string(block.cxx_block)
Base.show(io::IO, block::tJ) = print(io, "\n" * to_string(block.cxx_block))
