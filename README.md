![license](https://img.shields.io/badge/license-Apache%202.0-blue)
[![docs](https://img.shields.io/badge/Documentation-here-red.svg)](https://awietek.github.io/xdiag)
[![Linux CI](https://github.com/awietek/xdiag/actions/workflows/linux.yml/badge.svg?style=for-the-badge)](https://github.com/awietek/xdiag/actions/workflows/linux.yml)
[![Mac OSX CI](https://github.com/awietek/xdiag/actions/workflows/osx.yml/badge.svg?style=for-the-badge)](https://github.com/awietek/xdiag/actions/workflows/osx.yml)
[![Julia CI](https://github.com/awietek/XDiag.jl/actions/workflows/CI.yml/badge.svg?style=for-the-badge)](https://github.com/awietek/XDiag.jl/actions/workflows/CI.yml)
[![DOI](https://zenodo.org/badge/169422780.svg)](https://zenodo.org/badge/latestdoi/169422780)


# XDiag
## High-performance Yxact Diagonalization Routines and Algorithms

A Julia library to perform efficient Exact Diagonalizations of quantum many body systems. 

### Features:
- Basic algebra of operators in quantum many-body systems
- Iterative linear algebra for computing eigendecompositions and time-evolutions (e.g. Lanczos algorithm)
- Local spin, t-J, or fermionic models
- Full support of generic space group symmetries
- parallelization using OpenMP
- based on C++ library [xdiag](https://github.com/awietek/xdiag)

### Installation:
Enter the package mode using `]` in the Julia REPL and add the following two packages
```bash
add https://github.com/awietek/XDiag_jll.jl.git
add https://github.com/awietek/XDiag.jl.git
```

### Example Code:

```julia
using XDiag

let 
    N = 16;
    nup = N ÷ 2;
    block = Spinhalf(N, nup);
    
    # Define the nearest-neighbor Heisenberg model
    ops = OpSum()
    for i in 1:N
        ops += Op("HB", "J", [i-1, i % N])
    end
    ops["J"] = 1.0;

    set_verbosity(2);           # set verbosity for monitoring progress
    e0 = eigval0(ops, block);   # compute ground state energy

    println("Ground state energy: $e0");
end
```

### Documentation
The full documentation is available at [awietek.github.io/xdiag](https://awietek.github.io/xdiag).

### About
author:   Alexander Wietek
license:   Apache License 2.0
