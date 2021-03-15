#!/bin/bash

input_forlder=$1

echo "collect all statistics from experiments"
grep -r -h  "\[stats\]" "${input_forlder}" > "${input_forlder}/experiments.stat"
