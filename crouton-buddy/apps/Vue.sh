#!/bin/bash

# Application display name
Vue_App="Vue CLI SDK"

# Ensure dependencies
vue_Ready() {
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
Vue_Install() {
    if (( ! $(vue_Ready) )); then
        cbError "Missing Dependency: NPM"
    else
        # Install Vue
        sudo npm install -y vue-cli -g
    fi
}

# Application verification function
# Return 0 if installed, 1 if not installed
Vue_Verify() {
    (( ! $(vue_Ready) )) && return 1

    # @todo: Determine correct verification
    return 0
}
