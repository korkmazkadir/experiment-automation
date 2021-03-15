#!/bin/bash

func_send_message(){
    local message=$1
    local current_config=$2
    local batch_version=$3
    # should be absolute
    local file_path=$4
    
    #Read from current experiment config file
    local macroblock_size=$( jq .BAStar.MacroBlockSize $current_config )

    #Read from current experiment config file
    local concurrency_constant=$( jq .BAStar.ConcurrencyConstant $current_config )

    formatted_message="*[Batch:${batch_version}, Macroblock:${macroblock_size}, CC:${concurrency_constant}]* - _${message}_"

    if [ -z "${file_path}" ]; 
    then
        result=$(cd slack; ./send_message.py "${formatted_message}" )
    else
        result=$(cd slack; ./upload_file.py "${file_path}" "${formatted_message}" )
    fi

    
    echo "${result}"
}


func_send_message "Hello Kadir" "./config.json" 10 ""

report_path=$(readlink -m "./batch/conducted_experiments/throughput_and_latency_report.pdf")

echo "${report_path}"

func_send_message "Experiment report ready" "./config.json" 10 "${report_path}"
