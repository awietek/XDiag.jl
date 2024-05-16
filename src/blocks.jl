function Base.show(io::IO, block::Spinhalf)
    print_pretty("xdiag::Spinhalf", block)
end

function Base.show(io::IO, block::Electron)
    print_pretty("xdiag::Electron", block)
end

function Base.show(io::IO, block::tJ)
    print_pretty("xdiag::tJ", block)
end

function Base.size(block::Union{Spinhalf,tJ,Electron})
    return size(block)
end
