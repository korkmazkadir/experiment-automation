#!/bin/bash

input_forlder=$1

echo "collect all statistics from experiments"

# removes previos stat file
rm "${input_forlder}/experiments.stat"

grep -r -h  --exclude="${input_forlder}/experiments.stat"  "\[stats\]" "${input_forlder}" > "${input_forlder}/experiments.stat"
