#!/bin/bash

source ./scripting.sh

function run_dev_app() {
    echo "Running dev Maya..."
    execute fastapi dev main.py --reload
}

function run_app() {
    echo "Running fast api app..."
    execute fastapi run main.py
}

function main() {
  set_bash_error_handling
  go_to_project_root_directory
  run_dev_app
#  run_app
}

main