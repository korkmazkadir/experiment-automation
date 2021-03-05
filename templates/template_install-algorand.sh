#!/bin/bash

# Text color
LG='\e[92m'
NC='\033[0m'

>&2 echo -e "${LG}Killig algorand processes (if exists any)${NC}"
pkill algorand

>&2 echo -e "${LG}Deleting all files from home directory${NC}"
shopt -s extglob
rm -r !(experiment-artifacts.zip)

>&2 echo -e "${LG}Deleting tc rules (if exists any)${NC}"
sudo tc qdisc del dev eno1 root

>&2 echo -e "${LG}Removing old artifacts...${NC}"
sudo rm -rf ./Git

# Creates Git Folder
>&2 echo -e "${LG}Unzipping experiment-artifacts...${NC}"
unzip experiment-artifacts.zip

>&2 echo -e "${LG}Deletes unnecessary files from the home directory${NC}"
rm -f *.zip

# Ends ssh session
exit
