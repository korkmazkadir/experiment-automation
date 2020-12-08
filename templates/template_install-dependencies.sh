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

>&2 echo -e "${LG}updating...${NC}"
sudo apt-get -y update

>&2 echo -e "${LG}installing trickle...${NC}"
sudo apt install -y trickle

>&2 echo -e "${LG}installing zip...${NC}"
sudo apt-get install -y zip

>&2 echo -e "${LG}installing zip...${NC}"
sudo apt-get install -y unzip

>&2 echo -e "${LG}Removing old artifacts...${NC}"
sudo -rm ./Git

# Creates Git Folder
>&2 echo -e "${LG}Unzipping experiment-artifacts...${NC}"
unzip experiment-artifacts.zip

>&2 echo -e "${LG}Unzipping speed test...${NC}"
unzip distribution_amd64_linux.zip

>&2 echo -e "${LG}Deletes unnecessary files from the home directory${NC}"
rm *.zip

# Ends ssh session
exit
