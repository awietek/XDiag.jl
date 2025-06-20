# SPDX-FileCopyrightText: 2025 Alexander Wietek <awietek@pks.mpg.de>
#
# SPDX-License-Identifier: Apache-2.0

struct Spinhalf <: Block
    cxx_block::cxx_Spinhalf
end
convert(::Type{T}, block::cxx_Spinhalf) where T <: Spinhalf = Spinhalf(block)

# Constructors
Spinhalf() = Spinhalf(construct_Spinhalf())
Spinhalf(nsites::Int64, backend::String="auto") =
    Spinhalf(construct_Spinhalf(nsites, backend))
Spinhalf(nsites::Int64, nup::Int64, backend::String="auto") =
    Spinhalf(construct_Spinhalf(nsites, nup, backend))
Spinhalf(nsites::Int64, irrep::Representation, backend::String="auto") =
    Spinhalf(construct_Spinhalf(nsites, irrep.cxx_representation, backend))
Spinhalf(nsites::Int64, nup::Int64, irrep::Representation, backend::String="auto") =
    Spinhalf(construct_Spinhalf(nsites, nup, irrep.cxx_representation, backend))

# Methods
nsites(block::Spinhalf)::Int64 = nsites(block.cxx_block)
index(block::Spinhalf, pstate::ProductState)::Int64 =
    index(block.cxx_block, pstate.cxx_product_state) + 1
Base.isreal(block::Spinhalf)::Bool = isreal(block.cxx_block)
dim(block::Spinhalf)::Int64 = dim(block.cxx_block)
Base.size(block::Spinhalf)::Int64 = size(block.cxx_block)

# Iterators
function Base.iterate(block::Spinhalf)
    if size(block) > 0
        b = _begin(block.cxx_block)
        return ProductState(_deref(b)), b
    else
        return nothing
    end
end

function Base.iterate(block::Spinhalf, state)
    _incr(state)
    if state != _end(block.cxx_block)
        return ProductState(_deref(state)), state
    else
        return nothing
    end
end

# Output
to_string(block::Spinhalf)::String = to_string(block.cxx_block)
Base.show(io::IO, block::Spinhalf) = print(io, "\n" * to_string(block.cxx_block))
