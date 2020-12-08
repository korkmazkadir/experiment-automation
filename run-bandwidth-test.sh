#!/bin/bash

# Imports machines.sh
source machines.sh

echo "--------------------- Starting Web Server ------------------------"

machine=${machines[0]}

# Get username and ip address from ssh host name
IFS='@' read -ra tokens <<< "${machine}"
web_server_ip_address=${tokens[1]}

echo "==> Starting web server on the first machine: ${web_server_ip_address}"

cat ./templates/template_start-web-server.sh | ssh -q -t "${machine}" > /dev/null


echo "--------------------- Running Bandwidth Test ------------------------"

# Testing speed on machines
for machine in "${machines[@]}"
do

    echo "==> Running speed test on machine: ${machine}"

    sed -e "s/\${1}/${web_server_ip_address}/" ./templates/template_run-bandwidth-test.sh | ssh -q -t "${machine}" > /dev/null

done