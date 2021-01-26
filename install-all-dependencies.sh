#!/bin/bash

# Imports machines.sh
source machines.sh

# The first argument is the path of the algorand-go-implementation binary
if [ "$1" == "" ]; then
    echo "You should provide the path of experiment-artifacts.zip file!"
    exit 1
fi


echo "--------------------- Uploading Binaries ------------------------"

# Keeps pids of ssh processes to wait later
ssh_pids=()

function wait_for_processes {
  # Wait to finish all previous processes
  for pid in "${ssh_pids[@]}"; do
      wait $pid
  done
}

# Installing dependencies on machines
for machine in "${machines[@]}"
do

    echo "==> Uploading go binaries on machine: ${machine}"

    scp "${1}" "${machine}:~/"
    
    # Adds the pid of last ssh process to the list
    #ssh_pids=(${ssh_pids[@]} $!)

done

#wait_for_processes

echo "--------------------- Installing Dependencies ------------------------"
ssh_pids=()

# Installing dependencies on machines
for machine in "${machines[@]}"
do
    echo "==> Installing dependencies on machine: ${machine}"

    cat ./templates/template_install-dependencies.sh | ssh -T "${machine}" > /dev/null


done

