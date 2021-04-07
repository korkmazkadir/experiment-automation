#!/bin/bash

if [ ! -d "./batch" ] 
then
    echo "The batch directory does not exist. You should create one  manually." 
    exit -1
fi


macroblock_sizes=(512 1000)
concurrency_constants=(2 1)

file_index=1
for macroblock_size in "${macroblock_sizes[@]}"
do
    macroblock_size=$(($macroblock_size * 1000))
    for cc in "${concurrency_constants[@]}"
    do
        printf -v file_name "%04d_%d_%d.json" ${file_index} ${macroblock_size} ${cc}

	#if [ "$cc" = 1 ]; then
    #           mutex=true
    #    else
    #           mutex=false
    #    fi
    #
    # --arg m "$mutex" 
    # | .Network.BigMessageMutex =($m|test("true"))

        echo "${file_name}"
        jq --arg a "$macroblock_size" --arg b "$cc" '.BAStar.MacroBlockSize =($a|tonumber) | .BAStar.ConcurrencyConstant =($b|tonumber)   ' config.json > "./batch/experiments_to_conduct/${file_name}"

        ((file_index++))
    done
	

done

