using YaoPastaQ
using Documenter

DocMeta.setdocmeta!(YaoPastaQ, :DocTestSetup, :(using YaoPastaQ); recursive=true)

makedocs(;
    modules=[YaoPastaQ],
    authors="Roger-Luo <rogerluo.rl18@gmail.com> and contributors",
    repo="https://github.com/QuantumBFS/YaoPastaQ.jl/blob/{commit}{path}#{line}",
    sitename="YaoPastaQ.jl",
    format=Documenter.HTML(;
        prettyurls=get(ENV, "CI", "false") == "true",
        canonical="https://QuantumBFS.github.io/YaoPastaQ.jl",
        assets=String[],
    ),
    pages=[
        "Home" => "index.md",
    ],
)

deploydocs(;
    repo="github.com/QuantumBFS/YaoPastaQ.jl",
)
