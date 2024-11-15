#!/bin/bash

# ANSI color codes
export RED='\033[0;31m'
export BLUE='\033[0;34m'
export GREEN='\033[0;32m'
export YELLOW='\033[0;33m'
export WHITE='\033[0;37m'
export NC='\033[0m'

function set_bash_error_handling() {
    set -o errexit
    # This option tells Bash to trace the ERR signal through functions and pipelines. This means that if a command in a function or pipeline exits with a non-zero status, the ERR signal will be sent to the next command in the pipeline. This can be helpful for debugging errors in long pipelines.
    set -o errtrace
    # This option tells Bash to treat unset variables as an error. This means that if a command tries to use an unset variable, the script will exit with a non-zero status. This can help to prevent errors from occurring due to typos or missing variables.
    set -o nounset
    # This option tells Bash to set the exit status of a pipeline to the status of the last command to exit with a non-zero status. This means that if any command in a pipeline exits with a non-zero status, the entire pipeline will exit with a non-zero status. This can help to ensure that errors in pipelines are not silently ignored.
    set -o pipefail
}

function go_to_project_root_directory() {
    cd "$(git rev-parse --show-toplevel)"
}

# Expects 1 string parameter message and 1 optional string parameter color
function println() {
    if [ "$#" -lt 1 ]; then
        echo "Usage: println <message> [color] or println <message>"
        return 1
    fi

    local message="$1"
    local color=${2:-$YELLOW}

    echo -e "\n${color}${message}${NC}"
}

# Expects 1 string parameter command
function execute() {
    local command="$@"

    println "Running command: $command"

    eval "$command"

    println "Command: $command was successful!" "$GREEN"
}

function prompt_pause() {
    read -n 1 -s -r -p "Press any key to continue once the above actions are complete..."
}

export -f set_bash_error_handling
export -f go_to_project_root_directory
export -f println
export -f prompt_pause