#!/bin/bash

# Application display name
Nodemon_App="Nodemon change monitor daemon"

# Ensure dependencies
nodemon_Ready() {
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
Nodemon_Install() {
    if (( ! $(nodemon_Ready) )); then
        cbError "Missing Dependency: NPM"
    else
        # Install Nodemon
        sudo npm install -y nodemon -g
    fi
}

# Application verification function
# Return 0 if installed, 1 if not installed
Nodemon_Verify() {
    (( ! $(nodemon_Ready) )) && return 1

    # @todo: Determine correct verification
    return 0
}
