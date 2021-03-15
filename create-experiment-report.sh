#!/bin/bash

data_folder=$1
config_file=$2
output_folder=$3
output_file_name=$4

timestamp=$(date +"%d-%m-%Y %H:%M:%S")

current_pwd=$(pwd)

report="${current_pwd}/reports/experiment-report.Rmd"

R -e "Sys.setenv(RSTUDIO_PANDOC='/usr/lib/rstudio/bin/pandoc'); rmarkdown::render('${report}', output_dir='${output_folder}', output_file='${output_file_name}.pdf')" \
    --args "${data_folder}" "${config_file}" "${timestamp}"


#################
#./create-experiment-report.sh /Users/kadir/Git/experiment-automation/batch/conducted_experiments/512000/512000_CC1/stats /Users/kadir/Git/experiment-automation/batch/conducted_experiments/512000/512000_CC1/0001_512000_1.json /Users/kadir/Git/experiment-automation/batch/conducted_experiments/512000/512000_CC1/ experiment_report_512000_CC1
# https://stackoverflow.com/questions/28432607/pandoc-version-1-12-3-or-higher-is-required-and-was-not-found-r-shiny
# Use this for linux: Sys.setenv(RSTUDIO_PANDOC='/usr/lib/rstudio/bin/pandoc')
##################