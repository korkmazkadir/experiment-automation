#!/bin/bash

# first argument is the username on the machine
# Second argument is the ip address of the host

#cd ~/Git/algorand-go-implementation/output/
rm -f "./${2}_logs.zip"

# Collects logs in a zip file
zip -j "./${2}_logs.zip" ./Git/algorand-go-implementation/output/*

#mv "./${2}_logs.zip" "~/${2}_logs.zip"

# ends the current ssh session
exit



