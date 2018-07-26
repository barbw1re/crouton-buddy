#!/bin/bash

# Application display name
Bower_App="Bower package manager"

# Ensure dependencies
bower_Ready() {
    # Ensure we have npm installed
    npm -v > /dev/null 2>&1
    if (( $? )); then
        echo 0
        return 0
    fi
    echo 1
    return 1
}

# Application install function
Bower_Install() {
    if (( ! $(bower_Ready) )); then
        cbError "Missing Dependency: NPM"
    else
        # Install Bower
        sudo npm install -y bower -g
    fi
}

# Application verification function
# Return 0 if installed, 1 if not installed
Bower_Verify() {
    (( ! $(bower_Ready) )) && return 1

    # @todo: Determine correct verification
    return 0
}
