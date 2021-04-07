#!/bin/bash


# Text color
LG='\e[92m'
LM='\e[95m'
NC='\033[0m'

# Changes directory
cd ~/Git/algorand-go-implementation/

>&2 echo -e "${LM}Deleting tc rules${NC}"
sudo tc qdisc del dev eno1 root

#use the script
pkill algorand

# Delete all experiment data and removes executable
if [ -f Makefile ]; then
    make clean
else 
    >&2 echo -e "${LG}Removing output folder...${NC}"
    ./kill-processes.sh
    rm -rf output
fi

>&2 echo -e "${LM}Deleting PID file${NC}"
cat /dev/null > process.pids


#Kills all processess
#kill -9 -1
