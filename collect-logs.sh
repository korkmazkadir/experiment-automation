#!/bin/bash

# Imports machines.sh
source machines.sh

# Folder name is created using a formatted date time string
# This folder is used to store collected stat files from machines
date_string=$(date '+%Y-%m-%d_%H:%M:%S')
folder_name="output/logs/${date_string}"


if [ ! -d "./${folder_name}" ]; then
  mkdir -p "./${folder_name}"
fi

echo "--------------------- Zipping log Files ------------------------"

# Creates log files on machines
for machine in "${machines[@]}"
do
    echo "===> Creating the zip file on machine: ${machine}"

    # Get username and ip address from ssh host name
    IFS='@' read -ra tokens <<< "${machine}"

    user_name=${tokens[0]}
    ip_address=${tokens[1]}

    sed -e "s/\${1}/${user_name}/" -e "s/\${2}/${ip_address}/" ./templates/template_gether-logs.sh | ssh -t "${machine}" > /dev/null

done

echo "--------------------- Collecting zip Files ------------------------"

# Collect log files from machines
for machine in "${machines[@]}"
do

    echo "===> Getting the zip file from machine: ${machine}"

    # Get username and ip address from ssh host name
    IFS='@' read -ra tokens <<< "${machine}"

    user_name=${tokens[0]}
    ip_address=${tokens[1]}

    
    scp "${machine}:~/${ip_address}_logs.zip" "./${folder_name}/"

done
