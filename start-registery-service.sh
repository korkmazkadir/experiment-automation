#!/bin/bash

# Imports machines.sh
source machines.sh

source retry.sh

echo "--------------------- Starting Registery Service ------------------------"

machine=${machines[0]}

# Get username and ip address from ssh host name
IFS='@' read -ra tokens <<< "${machine}"
ip_address=${tokens[1]}

echo "==> Starting registery service on the first machine: ${ip_address}"

retry cat ./templates/template_start-registery-service.sh | ssh -t "${machine}" > /dev/null

