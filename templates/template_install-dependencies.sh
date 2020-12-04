#!/bin/bash

# Text color
LG='\e[92m'
NC='\033[0m'


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

# Ends ssh session
exit
