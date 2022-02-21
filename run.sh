#!/usr/bin/env bash
./get_data.sh
julia --threads 4 data_processing.jl
julia --threads 4 run_model.jl
