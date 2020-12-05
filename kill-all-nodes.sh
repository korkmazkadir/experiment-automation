#!/bin/bash

# Imports machines.sh
source machines.sh

echo "--------------------- Killing Nodes ------------------------"

# Keeps pids of ssh processes to wait later
ssh_pids=()

function wait_for_processes {
  # Wait to finish all previous processes
  for pid in "${ssh_pids[@]}"; do
      wait $pid
  done
}


# killing all nodes on machines
for machine in "${machines[@]}"
do

    echo "==> Killing nodes on machine: ${machine}"

    cat ./templates/template_kill-all-nodes.sh | ssh -t "${machine}" > /dev/null &

    # Adds the pid of last ssh process to the list
    ssh_pids=(${ssh_pids[@]} $!)

done

wait_for_processes