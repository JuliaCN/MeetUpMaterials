using Revise
using ProtoBuf
using V5RPC
import V5RPC:Field,EventArguments,destructure

struct MyStrategy <: Strategy
    robot_state
end

MyStrategy() = begin
    robot_state = map(1:5) do _
        Dict(:e_int => 0.0, :e_last => 0.0)
    end
    MyStrategy(robot_state)
end

V5RPC.get_team_info(::MyStrategy) = "Julia中文社区"

function V5RPC.get_instruction(s::MyStrategy, field::Field)
    map(1:5) do id
        instruction(s, V5RPC.destructure(field), id)
    end
end

function V5RPC.on_event(::MyStrategy, event_type::Int32, event_args::EventArguments)
    ty = lookup(V5RPC.EventType, event_type)
    println("Event: $ty $event_args")
end
#=
using DataStructures
using Makie
samples=Node(CircularBuffer{Float64}(100))
push!(samples[],0.0)
scene=lines(samples)
function addsample(x)
    global samples,scene
    push!(samples[],Float64(x))
    samples[]=samples[]
    center!(scene)
    update_limits!(scene)
    #display(scene)
end
=##
includet("impl.jl")

task1 = @async run(V5Server(MyStrategy(), 20000))
task2 = @async run(V5Server(EmptyStrategy(), 20001))
