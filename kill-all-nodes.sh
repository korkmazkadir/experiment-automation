#!/bin/bash

# Imports machines.sh
source machines.sh

echo "--------------------- Killing Nodes ------------------------"

# killing all nodes on machines
for machine in "${machines[@]}"
do

    echo "==> Killing nodes on machine: ${machine}"

    cat ./templates/template_kill-all-nodes.sh | ssh -t "${machine}" > /dev/null

done
