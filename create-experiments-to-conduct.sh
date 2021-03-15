#!/bin/bash

if [ ! -d "./batch" ] 
then
    echo "The batch directory does not exist. You should create one  manually." 
    exit -1
fi


#macroblock_sizes=(512 1000 2000 4000 6000)
macroblock_sizes=(8000 10000)
concurrency_constants=(1 2 4 6 8)

file_index=26
for macroblock_size in "${macroblock_sizes[@]}"
do
    macroblock_size=$(($macroblock_size * 1000))
    for cc in "${concurrency_constants[@]}"
    do
        printf -v file_name "%04d_%d_%d.json" ${file_index} ${macroblock_size} ${cc}

        echo "${file_name}"
        jq --arg a "$macroblock_size" --arg b "$cc" '.BAStar.MacroBlockSize =($a|tonumber) | .BAStar.ConcurrencyConstant =($b|tonumber) ' config.json > "./batch/experiments_to_conduct/${file_name}"

        ((file_index++))
    done
	

done

