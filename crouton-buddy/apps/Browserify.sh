#!/bin/bash

# Application display name
Browserify_App="Browserify"

# Ensure dependencies
Browserify_Ready() {
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
Browserify_Install() {
    if (( ! $(browserify_Ready) )); then
        cbError "Missing Dependency: NPM"
    else
        # Install Browserify
        sudo npm install -y browserify -g
    fi
}

# Application verification function
# Return 0 if installed, 1 if not installed
Browserify_Verify() {
    (( ! $(browserify_Ready) )) && return 1

    # @todo: Determine correct verification
    return 0
}
