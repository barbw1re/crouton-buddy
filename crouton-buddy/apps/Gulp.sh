#!/bin/bash

# Application display name
Gulp_App="Gulp pre-compiler"

# Ensure dependencies
gulp_Ready() {
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
Gulp_Install() {
    if (( ! $(gulp_Ready) )); then
        cbError "Missing Dependency: NPM"
    else
        # Install Gulp
        sudo npm install -y gulp -g
    fi
}

# Application verification function
# Return 0 if installed, 1 if not installed
Gulp_Verify() {
    (( ! $(gulp_Ready) )) && return 1

    # @todo: Determine correct verification
    return 0
}
