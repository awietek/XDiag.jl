# SPDX-FileCopyrightText: 2025 Alexander Wietek <awietek@pks.mpg.de>
#
# SPDX-License-Identifier: Apache-2.0

product_state(block::Block, local_states::Vector{String};
              real::Bool=true)::State =
                  cxx_product_state(block.cxx_block,
                                    StdVector(StdString.(local_states)),
                                    real)

random_state(block::Block;
             real::Bool=true,
             seed::Int64=42,
             normalized::Bool=true)::State =
                 cxx_random_state(block.cxx_block, real, seed, normalized)

zero_state(block::Block; real::Bool=true, ncols::Int64=1)::State =
    cxx_zero_state(block.cxx_block, real, ncols)

Base.zero(state::State) = cxx_zero(state.cxx_state)
