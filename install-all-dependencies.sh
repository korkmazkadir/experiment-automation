#!/bin/bash

# Imports machines.sh
source machines.sh

# Text color
RED='\033[0;31m'
LM='\e[95m'
NC='\033[0m'

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

    ecode=1
    while [ $ecode -ne 0 ]
    do

        scp "${1}" "${machine}:~/"
        ecode=$?

        if [ "$ecode" -ne 0 ]; 
        then
            echo -e "${RED}It will retry 10 seconds later.${NC}"
            sleep 10
        fi

    done
    
    # Adds the pid of last ssh process to the list
    #ssh_pids=(${ssh_pids[@]} $!)

done

#wait_for_processes

echo "--------------------- Installing Dependencies ------------------------"
ssh_pids=()

# Installing dependencies on machines
for machine in "${machines[@]}"
do
    echo "===> Installing dependencies on machine: ${machine}"

    ecode=1

    while [ "$ecode" != 0 ]
    do 
        cat ./templates/template_install-dependencies.sh | ssh -T "${machine}" > /dev/null
        ecode=$?

        if (( $ecode != 0 ))
        then
            echo "An error occured, error code is ${ecode}, it will retry after sleeping 2 seconds"
            sleep 2
        fi
        
    done

done

