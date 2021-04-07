#!/bin/bash

# Imports machines.sh
source machines.sh

# Text color
RED='\033[0;31m'
LM='\e[95m'
NC='\033[0m'

# The first argument is the path of the config file
if [ "$1" == "" ]; then
    echo "You should provide the path of the config.json file!"
    exit 1
fi


if [ -f "$1" ]; then
    echo "$1 exists."
else 
    echo "$1 does not exist!"
    exit 1
fi


echo "--------------------- Uploading The Config File ------------------------"

# Collect stat files from machines
for machine in "${machines[@]}"
do

    echo "=> Uploading the config file to machine: ${machine}"

    ecode=1
    while [ $ecode -ne 0 ]
    do

        scp "${1}" "${machine}:~/Git/algorand-go-implementation/config.json"
        
        ecode=$?

        if [ "$ecode" -ne 0 ]; 
        then
            echo -e "${RED}It will retry 10 seconds later.${NC}"
            sleep 10
        fi

    done


done
