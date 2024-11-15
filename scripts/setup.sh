#!/bin/bash

source ./scripting.sh

PROJECT_NAME="pyboot"

function make_scripts_executable() {
  chmod +x ./scripts/install.sh ./scripts/run.sh ./scripts/scripting.sh ./scripts/setup.sh ./scripts/ship.sh
}

function miniconda() {
  if ! command -v conda &> /dev/null; then
    echo "Miniconda is not installed. Installing..."
    execute brew install --cask miniconda
  fi
}

function create_and_activate_conda_environment() {
  if ! conda env list | grep -q "$PROJECT_NAME"; then
    echo "Creating Conda environment..."
    execute conda create -y -n "$PROJECT_NAME" --file environment.yml
  fi

  # Check if the environment is already active
  if [[ -z "${CONDA_DEFAULT_ENV+x}" || "$CONDA_DEFAULT_ENV" != "$PROJECT_NAME" ]]; then
    echo "Activating Conda environment..."
    # Needed to activate the Conda environment in a script
    execute eval "$(conda shell.bash hook)" 
    execute conda activate "$PROJECT_NAME"
  else
    echo "Conda environment for '$PROJECT_NAME' is active!"
  fi
  
  conda env list
}

function conda_add_channel() {
    # Adds the conda-forge channel to the list of channels 
    conda config --add channels conda-forge
    # Sets the channel priority to strict which means that packages from the highest priority channel are always preferred
    conda config --set channel_priority strict
}

function display_success_message() {
  local -r green_color_code='\033[1;32m'
  local -r default_color_code='\033[00m'
  echo -e "${green_color_code}Machine setup for python development! 🚀${default_color_code}\n"
}

function main() {
  set_bash_error_handling
  go_to_project_root_directory
  make_scripts_executable
  miniconda
  conda_add_channel
  create_and_activate_conda_environment
  display_success_message
}

main