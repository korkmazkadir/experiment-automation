#!/bin/bash

data_file=$1
output_folder=$2
output_file_name=$3

timestamp=$(date +"%d-%m-%Y %H:%M:%S")

current_pwd=$(pwd)

report="${current_pwd}/reports/throughput-latency-report.Rmd"

R -e "Sys.setenv(RSTUDIO_PANDOC='/usr/lib/rstudio/bin/pandoc'); rmarkdown::render('${report}', output_dir='${output_folder}', output_file='${output_file_name}.pdf')" \
    --args "${data_file}" "${timestamp}"


#################
#./create-throughput-latency-report.sh /home/kadir/Git/experiment-automation/batch/conducted_experiments/experiments.stat /home/kadir/Git/experiment-automation/batch/conducted_experiments throughput_latency_report
#
# https://stackoverflow.com/questions/28432607/pandoc-version-1-12-3-or-higher-is-required-and-was-not-found-r-shiny
# Use this for linux: Sys.setenv(RSTUDIO_PANDOC='/usr/lib/rstudio/bin/pandoc')
##################