#!/bin/bash

if [ ! -d "./batch" ] 
then
    echo "The batch directory does not exist. You should create one  manually." 
    exit -1
fi

if [[ -z "${SLACK_BOT_TOKEN}" ]]; then
    echo "SLACK_BOT_TOKEN environment variable is not set!"
    exit -1
fi




# Define a timestamp function
func_timestamp() {
  date +%s
}

func_date_time(){
    echo $(date -r "$1")
}

# Define a function to count number of experiments
func_count_experiments(){
    
    experiment_count=0

    shopt -s nullglob
    for config_file in ./batch/experiments_to_conduct/*.json; do

        if [[ "$config_file" == './batch/experiments_to_conduct/version.json' ]]; then
            continue
        fi

        ((experiment_count++))
        #echo "${config_file}"
    done

    echo "$experiment_count"
}


func_get_next_experiment(){
    
    shopt -s nullglob
    for config_file in ./batch/experiments_to_conduct/*.json; do

        if [[ "$config_file" == './batch/experiments_to_conduct/version.json' ]]; then
            continue
        fi

        echo "$config_file"
        break

    done

}

func_get_current_experiment(){

    shopt -s nullglob
    for config_file in ./batch/current_experiment/*.json; do

        #creates id field
        experiment_id=$(date +%s)
        jq --arg a "$experiment_id" '.BAStar.ID =($a|tonumber)' "$config_file" > temp && mv temp "$config_file"
        >&2 echo "Experiment ID is ${experiment_id}"

        echo "$config_file"
        break
    done

}


func_number_of_nodes(){
    # uses pgrep to get PIDs of algorand processes
    result=$(ssh -o LogLevel=QUIET nuc2.maas "pgrep algorand-go-imp")
    # counts the number of lines, and trims spaces using xargs
    echo $?
    echo "$result" | wc -l | xargs
}


# imports machines.sh
source machines.sh

func_is_experiment_end(){
    random_nuc=${machines[$RANDOM % ${#machines[@]} ]}
    result=$(ssh -o LogLevel=QUIET $random_nuc "pgrep algorand-go-imp")
    exit_code=$?

    if [ "$exit_code" -eq 255 ]; then
        # SSH Error
        return 255
    fi

    if [ "$exit_code" -eq 1 ]; then
        #it means that pgrep could not find something
        return 1
    fi 

    node_count=$(echo "$result" | wc -l | xargs)
    echo "$node_count"

    echo "$random_nuc $ssh_exit_code $node_count"
    #there are no nodes running on the selected nuc so the experiment is finished
    return 0
}


func_wait_until_end_of_experiment(){
    count=0
    sleep_time=20

    while [ $count -le 5 ]
    do
        echo "$count"
        sleep "$sleep_time"
        func_is_experiment_end
        is_experiment_end=$?
        if [ "$is_experiment_end" -eq 1 ]; 
            then
                count=$(( $count + 1 ))
                sleep_time=0
            else
                sleep_time=20
                count=0
        fi

    done
    echo "End of the experiment"
}


func_move_next_experiment(){
    local experiment=$1
    mv "${experiment}" ./batch/current_experiment/
}



func_move_experiment_data(){
    # current experiment config file
    local current=$1

    #Read from current experiment config file
    macroblock_size=$( jq .BAStar.MacroBlockSize $current )

    #Read from current experiment config file
    concurrency_constant=$( jq .BAStar.ConcurrencyConstant $current )

    #Read from current experiment config file
    threshold_proposer=$( jq .BAStar.ThresholdProposer $current )

    experiment_folder="./batch/conducted_experiments/${macroblock_size}/${macroblock_size}_CC${concurrency_constant}_TP${threshold_proposer}/"

    # creates the folder inconducted experiments folder
    mkdir -p "${experiment_folder}"

    # moves the content of the current experiment
    mv ./batch/current_experiment/* "${experiment_folder}"

}


func_create_experiment_report(){

    local current_config=$1
    local current_pwd=$(pwd)

    #Read from current experiment config file
    local macroblock_size=$( jq .BAStar.MacroBlockSize $current_config )

    #Read from current experiment config file
    local concurrency_constant=$( jq .BAStar.ConcurrencyConstant $current_config )

    local output_folder="${current_pwd}/batch/current_experiment"
    local config_file_name="$(basename -- $current_config)"
    local current_config="${current_pwd}/batch/current_experiment/${config_file_name}"
    local stats="${output_folder}/stats"

    local report_name="report-${macroblock_size}_CC${concurrency_constant}"

    ./create-experiment-report.sh "${stats}" "${current_config}" "${output_folder}" "${report_name}"

    experiment_report_name="${report_name}"

    echo "${report_name}.pdf"
}

func_create_throughput_latency_report(){
    local current_pwd=$(pwd)
    local output_folder="${current_pwd}/batch/conducted_experiments"
    local stats_file="${output_folder}/experiments.stat"
    local report_name="throughput_and_latency_report"

    ./create-throughput-latency-report.sh "${stats_file}" "${output_folder}" "${report_name}"

    echo "${output_folder}/${report_name}.pdf"
}


func_send_message(){
    local message=$1
    # should be absolute
    local file_path=$2
    
    formatted_message="*[Batch:${batch_version}, Macroblock:${macroblock_size}, CC:${concurrency_constant}]* - _${message}_"

    if [ -z "${file_path}" ]; 
    then
        result=$(cd slack; ./send_message.py "${formatted_message}" )
    else
        result=$(cd slack; ./upload_file.py "${file_path}" "${formatted_message}" )
    fi

    
    echo "${result}"
}


func_upload_file(){
    local file_path=$1
    result=$(cd slack; .send_message.py "${formatted_message}" )
    echo "${result}"    
}


start_time=$(func_timestamp)
batch_version=$( jq .version ./batch/experiments_to_conduct/version.json )
experiment_count=$(func_count_experiments)
human_start_time=$(func_date_time "$start_time")


echo "Started: ${human_start_time}"
echo "Batch version: ${batch_version}"
echo "Number of experiments to conduct: ${experiment_count}"


# Delete experiment data
echo "******** Deleting experiment data before processing batch"
./delete-experiment-data.sh


next_experiment=$(func_get_next_experiment)

echo "******** The next experiment is ${next_experiment}"

while [ ! -z $next_experiment ]
do

    # Moves the next experiment to current experiment folder
    echo "Getting the next experiment"
    func_move_next_experiment "${next_experiment}"

    # Gets the current experiment
    current_experiment=$(func_get_current_experiment)

    #Read from current experiment config file
    macroblock_size=$( jq .BAStar.MacroBlockSize $current_experiment )
    #Read from current experiment config file
    concurrency_constant=$( jq .BAStar.ConcurrencyConstant $current_experiment )


    # 0) Observer log experiment started
    echo "******** Experiment started: ${current_experiment} "
    func_send_message "Experiment started" ""
    

    # 1) Start registery service
    echo "******** Starting the registery service"
    ./start-registery-service.sh

    # 2) Upload Config files
    func_send_message "Uploading config files" ""
    ./upload-config.sh "${current_experiment}"

    # 3) Deploy nodes
    func_send_message "Deploying nodes" ""

    number_of_machines=${#machines[@]}
    total_number_of_nodes=$( jq .NodeCount $current_experiment )
    echo "******** Deploying ${total_number_of_nodes} nodes. The number of machines is ${number_of_machines}"
    number_of_nodes_per_machine=$((  $total_number_of_nodes / $number_of_machines ))
    source deploy-nodes.sh "${number_of_nodes_per_machine}"

    # 4) Wait until the end of the experiment
    echo "******** Waiting for the end of the experiment"
    func_send_message "Waiting for the end of the experiment" ""
    func_wait_until_end_of_experiment

    # 5) Collect stats
    echo "******** Collecting stats"
    func_send_message "Collecting stats" ""
    mkdir ./batch/current_experiment/stats
    ./collect-statistics.sh "./batch/current_experiment/stats"

    # 6) Collect-logs
    echo "******** Collecting logs"
    func_send_message "Collecting logs" ""
    mkdir ./batch/current_experiment/logs
    ./collect-logs.sh "./batch/current_experiment/logs"

    # 7) Create experiment report
    echo "******** Creating experiment report"
    func_send_message "Creating experiment report" ""
    func_create_experiment_report "$current_experiment"
    
    # 8) Upload experiment report to the channel 
    echo "******** Pulishes the experiment report on slack channel"
    #### Get path of the report
    #func_create_experiment_report creates global variable experiment_report_name
    report_path=$(readlink -m "./batch/current_experiment/${experiment_report_name}.pdf")
    echo "----------------->REPORT PATH IS ${report_path}"
    func_send_message "The experiment report ready" "${report_path}"

    # 9) Move data of the experiment under the conducted experiments folder
    echo "********  Moving experiment data under conducted experiments folder"
    func_move_experiment_data "$current_experiment"

    # 10) Create throughput latency report
    echo "Creating the throughput and latency reports"
    func_send_message "Creating the throughput and latency report" ""
    ./merge-stats.sh "./batch/conducted_experiments/"
    throughput_latency_report_file=$(func_create_throughput_latency_report)


    # 11) Upload throughput report to the channel
    echo "******** Pulishes the throughput and latency report on slack channel"
    report_path=$(readlink -m "./batch/conducted_experiments/throughput_and_latency_report.pdf")
    func_send_message "The throughput and latency report ready" "${report_path}"

    # 12) Delete experiment data on machine
    echo "******** Deleting experiment data on machines"
    func_send_message "Deleting experiment data" ""
    source delete-experiment-data.sh

    #13) Remainign number of experiments
    experiment_count=$(func_count_experiments)
    func_send_message "Remaining number of experiments is ${experiment_count}" ""


    # Reads the next experiment to conduct
    next_experiment=$(func_get_next_experiment)

done
