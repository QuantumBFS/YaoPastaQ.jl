# YaoPastaQ

[![Stable](https://img.shields.io/badge/docs-stable-blue.svg)](https://QuantumBFS.github.io/YaoPastaQ.jl/stable)
[![Dev](https://img.shields.io/badge/docs-dev-blue.svg)](https://QuantumBFS.github.io/YaoPastaQ.jl/dev)
[![Build Status](https://github.com/QuantumBFS/YaoPastaQ.jl/workflows/CI/badge.svg)](https://github.com/QuantumBFS/YaoPastaQ.jl/actions)
[![Coverage](https://codecov.io/gh/QuantumBFS/YaoPastaQ.jl/branch/master/graph/badge.svg)](https://codecov.io/gh/QuantumBFS/YaoPastaQ.jl)

[Yao](https://github.com/QuantumBFS/Yao.jl) and [PastaQ](https://github.com/GTorlai/PastaQ.jl) integration library.

## Installation

<p>
YaoPastaQ is a &nbsp;
    <a href="https://julialang.org">
        <img src="https://raw.githubusercontent.com/JuliaLang/julia-logo-graphics/master/images/julia.ico" width="16em">
        Julia Language
    </a>
    &nbsp; package. To install Configurations,
    please <a href="https://docs.julialang.org/en/v1/manual/getting-started/">open
    Julia's interactive session (known as REPL)</a> and press <kbd>]</kbd> key in the REPL to use the package mode, then type the following command
</p>

```julia
pkg> add https://github.com/QuantumBFS/YaoPastaQ.jl
```
## Usage

This package provides a PastaQ register called `PastaQReg` and some functions to work with it. 

You can create a PastaQReg using

```julia
julia> using YaoPastaQ, Yao

julia> p = chain(3, put(1=>X), repeat(H,1:3))
nqubits: 3
chain
├─ put on (1)
│  └─ X
└─ repeat on (1, 2, 3)
   └─ H

julia> apply!(create_reg(3), p)
PastaQReg{ITensors.MPS}
    active qubits: 3/3
```

You can also use the `genlist` function, which can convert a block in Yao to a list which can be read and used by the functions of [PastaQ](https://github.com/GTorlai/PastaQ.jl)
```julia
julia> list = genlist(chain(3, put(1=>X), repeat(Rz(π/3),1:3)))
4-element Vector{Any}:
 ("X", 1)
 ("Rz", 1, (ϕ = 1.0471975511965976,))
 ("Rz", 2, (ϕ = 1.0471975511965976,))
 ("Rz", 3, (ϕ = 1.0471975511965976,))
```

## License

MIT License

