#!/bin/bash

#Openfile soft limit increased
ulimit -Sn 1000000

# Kills the registery service
kill -9 `cat ~/registery.pid`
pkill service-app

# Runs a new registery service
nohup ./Git/coordinator/service-app > ~/registery.log 2>&1 &

# Saves pid of the process
echo $! > ~/registery.pid

# ends the current ssh session
exit