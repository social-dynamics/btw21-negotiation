#!/bin/bash
wget https://www.bpb.de/system/files/datei/Wahl-O-Mat%20Bundestag%202021_Datensatz_v1.02.zip -P data
7z x -odata data/'Wahl-O-Mat Bundestag 2021_Datensatz_v1.02.zip'
rm data/'Wahl-O-Mat Bundestag 2021_Datensatz_v1.02.zip'
mv 'data/Wahl-O-Mat Bundestag 2021_Datensatz_v1.02.xlsx' data/wahlomat.xlsx
rm data/Hinweis.txt
julia data_processing.jl
