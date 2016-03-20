#!/bin/sh

set -e

julia simulation.jl $1
julia analysis.jl $1

