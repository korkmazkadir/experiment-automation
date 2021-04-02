#!/bin/bash

# Text color
RED='\033[0;31m'
LM='\e[95m'
NC='\033[0m'


retry(){

    ecode=1
    while [ $ecode -ne 0 ]
    do

        echo -e "${LM}" $@ ${NC}

        "$@"
        ecode=$?

        if [ "$ecode" -ne 0 ]; 
        then
            echo -e "${RED}It will retry 10 seconds later.${NC}"
            sleep 10
        fi

    done

}
