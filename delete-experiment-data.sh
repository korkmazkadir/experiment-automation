#!/bin/bash

# Imports machines.sh
source machines.sh

# Text color
RED='\033[0;31m'
LM='\e[95m'
NC='\033[0m'


echo "--------------------- Deleting Experiment Data ------------------------"

# Keeps pids of ssh processes to wait later
ssh_pids=()

function wait_for_processes {
  # Wait to finish all previous processes
  for pid in "${ssh_pids[@]}"; do
      wait $pid
  done
}

# deploying nodes on machines
for machine in "${machines[@]}"
do

    echo "==> Deleting experiment data on machine: ${machine}"


    cat  ./templates/template_delete-experiment-data.sh | ssh -T "${machine}" > /dev/null


done
