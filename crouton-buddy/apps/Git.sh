#!/bin/bash

# Application display name
Git_App="Git version control system"

# Application install function
Git_Install() {
    sudo apt install -y git
}

# Application verification function
# Return 0 if installed, 1 if not installed
Git_Verify() {
    git --version > /dev/null 2>&1
    return $?
}
