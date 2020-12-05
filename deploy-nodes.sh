#!/bin/bash

# Imports machines.sh
source machines.sh

# The first argument is the path of the config file
if [ "$1" == "" ]; then
    echo "You should provide the number of node per machine!"
    exit 1
fi

echo "--------------------- Deploying Nodes ------------------------"

# Keeps pids of ssh processes to wait later
ssh_pids=()

function wait_for_processes {
  # Wait to finish all previous processes
  for pid in "${ssh_pids[@]}"; do
      wait $pid
  done
}

number_of_nodes=$1

registery_machine=${machines[0]}
# Get username and ip address from ssh host name
IFS='@' read -ra tokens <<< "${registery_machine}"
registery_ip_address=${tokens[1]}

echo "==> Assumes that registery service running on: ${registery_ip_address}"


# deploying nodes on machines
for machine in "${machines[@]}"
do

    echo "==> Deploying nodes on machine: ${machine}"

    # Get username and ip address from ssh host name
    IFS='@' read -ra tokens <<< "${machine}"
    ip_address=${tokens[1]}

    sed -e "s/\${1}/${registery_ip_address}/" -e "s/\${2}/${number_of_nodes}/" -e "s/\${3}/${ip_address}/" ./templates/template_deploy-nodes.sh | ssh -t "${machine}" > /dev/null &

    # Adds the pid of last ssh process to the list
    ssh_pids=(${ssh_pids[@]} $!)

done

wait_for_processes
