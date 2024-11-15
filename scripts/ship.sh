#!/bin/bash

source ./scripting.sh

function main() {
    go_to_project_maya
    execute pytest
    execute git add .
    execute git commit
    execute git push
}

main