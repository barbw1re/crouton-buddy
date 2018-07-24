#!/bin/bash

# Application display name
React_App="React JS library"

# Ensure dependencies
react_Ready() {
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
React_Install() {
    if (( ! $(react_Ready) )); then
        cbError "Missing Dependency: NPM"
    else
        # Install React
        sudo npm install -y create-react-app create-react-native-app -g
    fi
}

# Application verification function
# Return 0 if installed, 1 if not installed
React_Verify() {
    (( ! $(react_Ready) )) && return 1

    # @todo: Determine correct verification
    return 0
}
