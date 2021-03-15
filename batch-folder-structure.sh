#!/bin/bash

if [ -d "./batch" ] 
then
    echo "The batch directory already exists. You should remove it manually." 
    exit -1
fi

mkdir batch

# Contains config files of experiments to conduct
mkdir ./batch/experiments_to_conduct

# Contains the config file of the current experiment
mkdir ./batch/current_experiment

# Contains data of the conducted experiments
# Logs, Stats, Config file, and the experiment report
mkdir ./batch/conducted_experiments


# Contains config files of experiments to conduct
# This file contains a version number
# This will be used to di'fferentiate different batches
printf '{\n\t"version":0\n}' > ./batch/experiments_to_conduct/version.json

