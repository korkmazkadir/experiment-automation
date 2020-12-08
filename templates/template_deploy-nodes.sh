#!/bin/bash


registery_address="${1}"
number_of_nodes="${2}"

# Exports public address
# This gets the IP address of the  machine on nuc cluster
export PUBLIC_ADDRESS=$(hostname -I)

# Text color
RED='\033[0;31m'
LM='\e[95m'
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

>&2 echo -e "${LM}Adding 50ms delay using TC rule: netem delay 50ms limit 32Mb${NC}"
sudo tc qdisc add dev eno1 root netem delay 50ms limit 32Mb


# Runs nodes
printf "${registery_address}\n${number_of_nodes}\n" | ./create-network-with-registery-trickle.sh

# Exits
exit
