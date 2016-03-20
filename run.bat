echo off

julia.exe simulation.jl %1
julia.exe analysis.jl %1

