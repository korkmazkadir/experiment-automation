#!/bin/bash

# Imports machines.sh
source machines.sh

# Text color
RED='\033[0;31m'
LM='\e[95m'
NC='\033[0m'


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

    IFS='.' read -ra tokens <<< "${ip_address}"
    host_name=${tokens[0]}

    ecode=1
    while [ $ecode -ne 0 ]
    do

        sed -e "s/\${1}/${registery_ip_address}/" -e "s/\${2}/${number_of_nodes}/" ./templates/template_deploy-nodes.sh | ssh -tt "${machine}" > /dev/null
        
        ecode=$?

        echo "Error code is ${ecode}"

        if [ "$ecode" -ne 0 ]; 
        then
            echo -e "${RED}It will retry 10 seconds later.${NC}"
            sleep 10
        fi

    done



done

