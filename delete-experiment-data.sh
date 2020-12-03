#!/bin/bash

# Imports machines.sh
source machines.sh

echo "--------------------- Deleting Experiment Data ------------------------"

# deploying nodes on machines
for machine in "${machines[@]}"
do

    echo "==> Deleting experiment data on machine: ${machine}"

    cat  ./templates/template_delete-experiment-data.sh | ssh -t "${machine}" > /dev/null

done
