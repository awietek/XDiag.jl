struct Bond
    type::AbstractString
    coupling::Union{AbstractString, Number}
    sites::Vector{Int64}
end

struct BondList
    bonds::Vector{Bond}
    couplings::Dict{AbstractString, Number}
end

BondList() = BondList([], Dict())
BondList(bonds::Vector{Bond}) = BondList(bonds, Dict())

function add!(bondlist::BondList, bond::Bond)
    push!(bondlist.bonds, bond)
end

function Base.:+(bonds::BondList, bond::Bond)
    add!(bonds, bond)
    return bonds
end

function Base.:setindex!(bonds::BondList, value::Number, coupling::AbstractString)
    bonds.couplings[coupling] = value 
end

# Functions to convert to the corrsponding cxx object
function cxx(bond::Bond)
    return cxx_Bond(bond.type, bond.coupling, StdVector(bond.sites))
end

function cxx(bondlist::BondList)
    bonds_cxx = cxx_BondList(StdVector(cxx.(bondlist.bonds)))
    for (key, val) in bondlist.couplings
        set_coupling(bonds_cxx, key, ComplexF64(val))
    end
    return bonds_cxx
end
