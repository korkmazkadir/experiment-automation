#!/bin/bash

# Imports machines.sh
source machines.sh

echo "--------------------- Installing Dependencies ------------------------"

# Creates stat files on machines
for machine in "${machines[@]}"
do
    echo "==> Installing dependencies on machine: ${machine}"

    cat ./templates/template_install-dependencies.sh | ssh -t "${machine}" > /dev/null

done
