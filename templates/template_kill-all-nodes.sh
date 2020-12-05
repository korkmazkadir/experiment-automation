#!/bin/bash

# Text color
LM='\e[95m'
NC='\033[0m'

# Changes directory
cd ~/Git/algorand-go-implementation/

>&2 echo -e "${LM}Deleting TC rules${NC}"
sudo tc qdisc del dev eno1 root

# Kills all nodes
./kill-processes.sh

exit
