#!/bin/bash

# Imports machines.sh
source machines.sh

# Folder name is created using a formatted date time string
# This folder is used to store collected stat files from machines
date_string=$(date '+%Y-%m-%d_%H:%M:%S')
folder_name="output/configs/${date_string}"


if [ ! -d "./${folder_name}" ]; then
  mkdir -p "./${folder_name}"
fi

echo "--------------------- Collecting Config Files ------------------------"

# Collect log files from machines
for machine in "${machines[@]}"
do

    echo "===> Getting the config file from machine: ${machine}"

    # Get username and ip address from ssh host name
    IFS='@' read -ra tokens <<< "${machine}"

    user_name=${tokens[0]}
    ip_address=${tokens[1]}

    scp "${machine}:~/Git/algorand-go-implementation/config.json" "./${folder_name}/${ip_address}_config.json"

done
