#!/bin/bash

# Application display name
Docker_App="Docker visualization environment"

# Application install function
Docker_Install() {
    sudo apt install -y docker-ce
}

# Application verification function
# Return 0 if installed, 1 if not installed
Docker_Verify() {
    docker -v > /dev/null 2>&1
    return $?
}
