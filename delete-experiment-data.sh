#!/bin/bash

# Imports machines.sh
source machines.sh

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
