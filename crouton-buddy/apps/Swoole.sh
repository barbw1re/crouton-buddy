#!/bin/bash

# Application display name
Swoole_App="Swoole asynchronous PHP framework"

# Ensure dependencies
swoole_Ready() {
    # Ensure we have php installed
    php -v > /dev/null 2>&1
    if (( $? )); then
        echo 0
        return 0
    fi
    echo 1
    return 1
}

# Application install function
Swoole_Install() {
    if (( ! $(swoole_Ready) )); then
        cbError "Missing Dependency: PHP"
    else
        # Install Swoole
        sudo pecl install swoole -y
    fi
}

# Application verification function
# Return 0 if installed, 1 if not installed
Swoole_Verify() {
    (( ! $(swoole_Ready) )) && return 1

    # @todo: Determine correct verification
    return 0
}
