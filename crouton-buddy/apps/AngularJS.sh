#!/bin/bash

# Application display name
AngularJS_App="AngularJS Framework"

# Ensure dependencies
angularjs_Ready() {
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
AngularJS_Install() {
    if (( ! $(angularjs_Ready) )); then
        cbError "Missing Dependency: NPM"
    else
        # Install AngularJS
        sudo npm install -y @angular/cli @angular/service-worker ng-pwa-tools -g
    fi
}

# Application verification function
# Return 0 if installed, 1 if not installed
AngularJS_Verify() {
    (( ! $(angularjs_Ready) )) && return 1

    # @todo: Determine correct verification
    return 0
}
