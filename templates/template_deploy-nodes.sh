#!/bin/bash


registery_address="${1}"
number_of_nodes="${2}"

# Exports public address
# This gets the IP address of the  machine on nuc cluster
export PUBLIC_ADDRESS=$(hostname -I)

# Text color
RED='\033[0;31m'
NC='\033[0m'

# Changes directory
cd ~/Git/algorand-go-implementation/

if [ -d "./output/" ]; then
    >&2 echo -e "${RED}Machine contains experiment data. You should clean it before deploying new nodes!${NC}"
    exit 1
fi

# Compiles the project
if [ -f Makefile ]; then
    make
fi

# Runs nodes
printf "${registery_address}\n${number_of_nodes}\n" | ./create-network-with-registery-trickle.sh

# Exits
exit
