#!/bin/bash

# Imports machines.sh
source machines.sh

# The first argument is the path of the algorand-go-implementation binary
if [ "$1" == "" ]; then
    echo "You should provide the path of experiment-artifacts.zip file!"
    exit 1
fi


echo "--------------------- Uploading Binaries ------------------------"

# Installing dependencies on machines
for machine in "${machines[@]}"
do

    echo "==> Uploading go binaries on machine: ${machine}"

    scp "${1}" "${machine}:~/"

done


echo "--------------------- Installing Dependencies ------------------------"

# Installing dependencies on machines
for machine in "${machines[@]}"
do
    echo "==> Installing dependencies on machine: ${machine}"

    cat ./templates/template_install-dependencies.sh | ssh -t "${machine}" > /dev/null

done


