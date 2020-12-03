#!/bin/bash

# first argument is the username on the machine
# Second argument is the ip address of the host

# The first argument is the IP address of the machine
#export PUBLIC_IP=${2}

# Nodes are strated in this folder
#cd "/home/${1}/Git/algorand-go-implementation"

# Collects stats in a .stat file
tail --silent -n +1  ~/Git/algorand-go-implementation/output/*.log | grep "\[stats\]" > "${2}.stat"

# ends the current ssh session
exit

