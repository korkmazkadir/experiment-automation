#!/bin/bash

# Kills the registery service
kill -9 `cat ~/web-server.pid`

./create-files.sh

# Runs a new registery service
nohup ./speed-test-server_linux-amd64 > ~/web-server.log 2>&1 &

# Saves pid of the process
echo $! > ~/web-server.pid

# ends the current ssh session
exit
