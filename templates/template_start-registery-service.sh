#!/bin/bash

# Kills the registery service
kill -9 `cat ~/registery.pid`

# Runs a new registery service
nohup ./Git/coordinator/service-app > ~/registery.log 2>&1 &

# Saves pid of the process
echo $! > ~/registery.pid

# ends the current ssh session
exit