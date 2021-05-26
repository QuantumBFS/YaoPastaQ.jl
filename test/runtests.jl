using YaoPastaQ, Yao
using PastaQ: MPS, productstate
using Test

@testset "YaoPastaQ.jl" begin
    @test genlist(chain(3, put(2 => X), repeat(X, 1:3))) ==  Any[("X", 2), ("X", 1), ("X", 2), ("X", 3)] 
    @test genlist(chain(3, put(2 => Y), repeat(Y, 1:3), put(1:3 => chain(3, put(1=>X))))) == Any[("Y", 2), ("Y", 1), ("Y", 2), ("Y", 3), ("X", 1)] 
    @test genlist(chain(3, put(1 => H), repeat(H, 1:3), put(1:3 => chain(3, put(1 => Z))))) == Any[("H", 1), ("H", 1), ("H", 2), ("H", 3), ("Z", 1)] 
    
    testgate = chain(3, put(2 => X), put(3 => im*Y), repeat(H, 1:2), put(1:2 => chain(2, put(1 => X))), put(1 => shift(π/2)), put(1 => shift(π/4)), put(3=>Rx(π/3)), swap(1,2), control(1:2, 3=>X), control(1, 3=>Rz(π/3)), control(1, 2=>Y), control(1, 2:3=>SWAP)) 
    testgate2 = chain(4, control(1:3, 4=>X)) 
    
    @test genlist(testgate) == Any[("X", 2), ("iY", 3), ("H", 1), ("H", 2), ("X", 1), ("Phase", 1), ("π/8", 1), ("Rx", 3, (θ = 1.0471975511965976,)), ("SWAP", (1, 2)), ("Toffoli", (1, 2, 3)), ("CRz", (1, 3), (ϕ = 1.0471975511965976,)), ("CY", (1, 2)), ("Fredkin", (1, 2, 3))]
    @test genlist(testgate2) == Any[("CCCNOT", (1, 2, 3, 4))]
    @test nqubits(PastaQReg(3)) == 3
    @test PastaQReg(3) isa PastaQReg{MPS}
    @test measure(PastaQReg(3), 3) == [0 0 0; 0 0 0; 0 0 0]
    @test apply!(PastaQReg(3), chain(3, put(1=>X))) isa PastaQReg{MPS}
    @test PastaQReg(YaoBase.bit"0011") isa PastaQReg{MPS}
    @test fidelity(PastaQReg(3), PastaQReg(3)) == 1.0
    @test nactive(PastaQReg(YaoBase.bit"0011")) == 4
    @test PastaQReg(PastaQReg(3)) isa PastaQReg{MPS}
    @test PastaQReg(productstate(3)) isa PastaQReg{MPS}
end
