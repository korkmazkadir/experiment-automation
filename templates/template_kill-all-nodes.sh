#!/bin/bash

# Text color
YBG='\e[43m'
NC='\033[0m'

# Changes directory
cd ~/Git/algorand-go-implementation/

>&2 echo -e "${YBG}Deleting TC rules${NC}"
sudo tc qdisc del dev eno1 root

# Kills all nodes
./kill-processes.sh

exit
