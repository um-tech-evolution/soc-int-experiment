#!/bin/sh

set -e

julia simulation.jl | tee output.csv
julia analysis.jl

