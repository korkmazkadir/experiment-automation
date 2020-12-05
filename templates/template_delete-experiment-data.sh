#!/bin/bash


# Text color
LG='\e[92m'
YBG='\e[43m'
NC='\033[0m'

# Changes directory
cd ~/Git/algorand-go-implementation/

>&2 echo -e "${YBG}Deleting TC rules${NC}"
sudo tc qdisc del dev eno1 root

# Delete all experiment data and removes executable
if [ -f Makefile ]; then
    make clean
else 
    >&2 echo -e "${LG}Removing output folder...${NC}"
    rm -rf output
fi

exit
