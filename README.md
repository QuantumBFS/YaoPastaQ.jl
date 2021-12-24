# YaoPastaQ

[![Stable](https://img.shields.io/badge/docs-stable-blue.svg)](https://QuantumBFS.github.io/YaoPastaQ.jl/stable)
[![Dev](https://img.shields.io/badge/docs-dev-blue.svg)](https://QuantumBFS.github.io/YaoPastaQ.jl/dev)
[![Build Status](https://github.com/QuantumBFS/YaoPastaQ.jl/workflows/CI/badge.svg)](https://github.com/QuantumBFS/YaoPastaQ.jl/actions)
[![Coverage](https://codecov.io/gh/QuantumBFS/YaoPastaQ.jl/branch/master/graph/badge.svg)](https://codecov.io/gh/QuantumBFS/YaoPastaQ.jl)

To install, in the Julia REPL do

```julia
julia> add https://github.com/QuantumBFS/YaoPastaQ.jl
```

For usage:

```julia
julia> using Yao, YaoPastaQ
julia> YaoPastaQ.genlist(put(3, 3=>Y))
1-element Vector{Any}:
 ("Y", 3)
 
julia> x = PastaQReg(bit"00110")
PastaQReg{ITensors.MPS}
    active qubits: 5/5

julia> nqubits(x)
5
```
