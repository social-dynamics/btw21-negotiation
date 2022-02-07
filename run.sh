#!/usr/bin/env bash
./get_data.sh
julia data_processing.jl
julia run_model.jl
