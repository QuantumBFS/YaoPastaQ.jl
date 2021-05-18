using Yao, YaoBlocks
testgate = chain(3, put(2 => X), put(3 => im*Y), repeat(H, 1:2), put(1:2 => chain(2, put(1 => X))), put(1 => shift(π/2)), put(1 => shift(π/4)))
flblock(blk::AbstractBlock) = YaoBlocks.Optimise.simplify(blk, rules=[YaoBlocks.Optimise.to_basictypes])
sublocs(subs, locs) = [locs[i] + 1 for i in subs]

function genlist(qc::AbstractBlock{N}, ncreg::Int) where N
    prog = []
    genlist!(prog, flblock(qc), [0:N - 1...], Int[])
    return collect(prog)
end

function genlist!(prog, qc_simpl::ChainBlock, locs, controls)
    for block in subblocks(qc_simpl)
        genlist!(prog, block, locs, controls)
    end
end

function genlist!(prog, blk::PutBlock{N,M}, locs, controls) where {N,M}
    genlist!(prog, blk.content, sublocs(blk.locs, locs), controls)
end

genlist!(prog, blk::XGate, locs, controls) = push!(prog, ("X", locs))
genlist!(prog, blk::YGate, locs, controls) = push!(prog, ("Y", locs))
genlist!(prog, blk::HGate, locs, controls) = push!(prog, ("H", locs))
genlist!(prog, blk::Scale{Val{im}, 1, YGate}, locs, controls) = push!(prog, ("iY", locs))
genlist!(prog, blk::TGate, locs, controls) = push!(prog, ("π/8", locs))
genlist!(prog, blk::ShiftGate{Float64}, locs, controls) = if(rad2deg(blk.theta) == 90.0)
                                                                    push!(prog, ("Phase", locs))
                                                                elseif(rad2deg(blk.theta) == 45.0)
                                                                    push!(prog, ("π/8", locs))
                                                                end
