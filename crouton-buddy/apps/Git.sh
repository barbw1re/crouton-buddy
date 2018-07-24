#!/bin/bash

Git_App="Git version control system"

Git_Install() {
    sudo apt install -y git
}

Git_Verify() {
    git --version >/dev/null 2>&1
    return $?
}
