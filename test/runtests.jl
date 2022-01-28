using YaoPastaQ, Yao
using PastaQ: MPS, productstate
using Test

@testset "YaoPastaQ.jl" begin
    @test genlist(chain(3, put(2 => X), repeat(X, 1:3))) ==  Any[("X", 2), ("X", 1), ("X", 2), ("X", 3)] 
    @test genlist(chain(3, put(2 => Y), repeat(Y, 1:3), put(1:3 => chain(3, put(1=>X))))) == Any[("Y", 2), ("Y", 1), ("Y", 2), ("Y", 3), ("X", 1)] 
    @test genlist(chain(3, put(1 => H), repeat(H, 1:3), put(1:3 => chain(3, put(1 => Z))))) == Any[("H", 1), ("H", 1), ("H", 2), ("H", 3), ("Z", 1)] 
    @test genlist(chain(3, kron(X, Y, ConstGate.S))) == Any[("X", 1), ("Y", 2), ("S", 3)] 
    @test genlist(chain(3, control(2, 1=>Rx(π/2)), control(2, 1=>Ry(π/3)))) == Any[("CRx", (2, 1), (ϕ = 1.5707963267948966,)), ("CRy", (2, 1), (ϕ = 1.0471975511965976,))]
    @test genlist(chain(2, control(2, 1=>shift(π/3)), put(1=>shift(π/4)))) == Any[("CPHASE", (2, 1), (ϕ = 1.0471975511965976,)), ("Phase", 1, (ϕ = 0.7853981633974483,))] 
    
    testgate = chain(3, put(2 => X), put(3 => im*Y), repeat(H, 1:2), put(1:2 => chain(2, put(1 => X))), put(3=>Rx(π/3)), swap(1,2), control(1:2, 3=>X), control(1, 3=>Rz(π/3)), control(1, 2=>Y), control(1, 2:3=>SWAP)) 
    testgate2 = chain(4, control(1:3, 4=>X)) 
    
    @test genlist(testgate) == Any[("X", 2), ("iY", 3), ("H", 1), ("H", 2), ("X", 1), ("Rx", 3, (θ = 1.0471975511965976,)), ("SWAP", (1, 2)), ("Toffoli", (1, 2, 3)), ("CRz", (1, 3), (ϕ = 1.0471975511965976,)), ("CY", (1, 2)), ("Fredkin", (1, 2, 3))]
    @test genlist(testgate2) == Any[("CCCNOT", (1, 2, 3, 4))]
    @test nqubits(create_reg(3)) == 3
    @test create_reg(3) isa PastaQReg{MPS}
    @test measure(create_reg(3), 3) == [0 0 0; 0 0 0; 0 0 0]
    @test apply!(create_reg(3), chain(3, put(1=>X))) isa PastaQReg{MPS}
    @test create_reg(YaoBase.bit"0011") isa PastaQReg{MPS}
    @test fidelity(create_reg(3), create_reg(3)) == 1.0
    @test nactive(create_reg(YaoBase.bit"0011")) == 4
    @test create_reg(create_reg(3)) isa PastaQReg{MPS}
    @test create_reg(productstate(3)) isa PastaQReg{MPS}
end
