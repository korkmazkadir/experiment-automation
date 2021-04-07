#!/bin/bash

# Imports machines.sh
source machines.sh

# Text color
RED='\033[0;31m'
LM='\e[95m'
NC='\033[0m'

echo "--------------------- Starting Registery Service ------------------------"

machine=${machines[0]}

# Get username and ip address from ssh host name
IFS='@' read -ra tokens <<< "${machine}"
ip_address=${tokens[1]}

echo "==> Starting registery service on the first machine: ${ip_address}"


ecode=1
while [ $ecode -ne 0 ]
do

    cat ./templates/template_start-registery-service.sh | ssh -t "${machine}" > /dev/null

    ecode=$?

    if [ "$ecode" -ne 0 ]; 
    then
        echo -e "${RED}It will retry 10 seconds later.${NC}"
        sleep 10
    fi

done