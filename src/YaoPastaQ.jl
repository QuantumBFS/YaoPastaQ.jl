module YaoPastaQ

using YaoBase, YaoBlocks
export genlist
flblock(blk::AbstractBlock) = YaoBlocks.Optimise.simplify(blk, rules=[YaoBlocks.Optimise.to_basictypes])
sublocs(subs, locs) = [locs[i] for i in subs]   

function genlist(x::AbstractBlock{N}) where N
    plist = []
    genlist!(plist, flblock(x), [1:N...], Int[])
    return plist
end

function genlist!(plist, qc_simpl::ChainBlock, locs, controls)
    for block in subblocks(qc_simpl)
        genlist!(plist, block, locs, controls)
    end
end

function genlist!(plist, blk::PutBlock{N,M}, locs, controls) where {N,M}
    genlist!(plist, blk.content, sublocs(blk.locs, locs), controls)
end

genlist!(plist, blk::XGate, locs, controls) = push!(plist, ("X", locs[1]))
genlist!(plist, blk::YGate, locs, controls) = push!(plist, ("Y", locs[1]))
genlist!(plist, blk::HGate, locs, controls) = push!(plist, ("H", locs[1]))
genlist!(plist, blk::ZGate, locs, controls) = push!(plist, ("Z", locs[1]))
genlist!(plist, blk::Scale{Val{im}, 1, YGate}, locs, controls) = push!(plist, ("iY", locs[1]))
genlist!(plist, blk::TGate, locs, controls) = push!(plist, ("π/8", locs[1]))

function genlist!(plist, blk::ShiftGate{Float64}, locs, controls) 
    if blk.theta == π/2
        push!(plist, ("Phase", locs[1]))
    elseif blk.theta == π/4
        push!(plist, ("π/8", locs[1]))
    end
end

genlist!(plist, blk::I2Gate, locs, controls) = push!(plist, ("Id", locs[1]))
genlist!(plist, blk::RotationGate{1, Float64, XGate}, locs, controls) = push!(plist, ("Rx", locs[1], (θ = blk.theta,)))
genlist!(plist, blk::RotationGate{1, Float64, YGate}, locs, controls) = push!(plist, ("Ry", locs[1], (θ = blk.theta,)))
genlist!(plist, blk::RotationGate{1, Float64, ZGate}, locs, controls) = push!(plist, ("Rz", locs[1], (ϕ = blk.theta,)))
genlist!(plist, blk::ControlBlock{2, XGate, 1, 1}, locs, controls) = push!(plist, ("CX", (blk.ctrl_locs[1], blk.locs[1])))
genlist!(plist, blk::ControlBlock{2, YGate, 1, 1}, locs, controls) = push!(plist, ("CY", (blk.ctrl_locs[1], blk.locs[1])))
genlist!(plist, blk::ControlBlock{2, ZGate, 1, 1}, locs, controls) = push!(plist, ("CZ", (blk.ctrl_locs[1], blk.locs[1])))
genlist!(plist, blk::ControlBlock{2, RotationGate{1, Float64, ZGate}, 1, 1}, locs, controls) = push!(plist, ("CRz", (blk.ctrl_locs[1], blk.locs[1]), (ϕ = blk.content.theta,)))
genlist!(plist, blk::SWAPGate, locs, controls) = push!(plist, ("SWAP", (locs[1], locs[2])))
genlist!(plist, blk::ControlBlock{3, XGate, 2, 1}, locs, controls) = push!(plist, ("Toffoli", (blk.ctrl_locs[1], blk.ctrl_locs[2], blk.locs[1])))
genlist!(plist, blk::ControlBlock{3, SWAPGate, 1, 2}, locs, controls) = push!(plist, ("Fredkin", (blk.ctrl_locs[1], blk.locs[1], blk.locs[2])))
genlist!(plist, blk::ControlBlock{4, XGate, 3, 1}, locs, controls) = push!(plist, ("CCCNOT", (blk.ctrl_locs[1], blk.ctrl_locs[2], blk.ctrl_locs[3], blk.locs[1])))
end
