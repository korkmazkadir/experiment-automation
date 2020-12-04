#!/bin/bash


# Text color
LG='\e[92m'
NC='\033[0m'

# Changes directory
cd ~/Git/algorand-go-implementation/

# Delete all experiment data and removes executable

if [ -f Makefile ]; then
    make clean
else 
    >&2 echo -e "${LG}Removing output folder...${NC}"
    rm -rf output
fi

exit
