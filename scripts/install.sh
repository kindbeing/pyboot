#!/bin/bash

source ./scripting.sh

PROJECT_NAME="pyboot"

function update_requirements() {
  echo "Installing requirements.txt..."
  execute eval "$(conda shell.bash hook)" 
  execute conda activate "$PROJECT_NAME"
  execute conda env update "$PROJECT_NAME" --file environment.yml --prune
}

function display_success_message() {
  local -r green_color_code='\033[1;32m'
  local -r default_color_code='\033[00m'
  echo -e "${green_color_code}Project dependencies installed successfully!🚀${default_color_code}\n"
}

function main() {
  set_bash_error_handling
  go_to_project_root_directory
  update_requirements
  display_success_message
#  source run.sh
#  run_dev_app
}

main