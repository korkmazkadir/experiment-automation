#!/bin/bash

# Imports machines.sh
source machines.sh

# The first argument is the path of the config file
if [ "$1" == "" ]; then
    echo "You should provide the path of the config.json file!"
    exit 1
fi


if [ -f "$1" ]; then
    echo "$1 exists."
else 
    echo "$1 does not exist!"
    exit 1
fi


echo "--------------------- Uploading The Config File ------------------------"

# Collect stat files from machines
for machine in "${machines[@]}"
do

    echo "=> Uploading the config file to machine: ${machine}"

    scp "${1}" "${machine}:~/Git/algorand-go-implementation/"

done
