#!/bin/bash

# Application display name
Composer_App="Composer Dependency Manager"

# Ensure dependencies
composer_Ready() {
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
Composer_Install() {
    if (( ! $(composer_Ready) )); then
        cbError "Missing Dependency: PHP"
    else
        # Install Composer
        curl -sS "https://getcomposer.org/installer" | sudo php -- --install-dir=/usr/local/bin --filename=composer
    fi
}

# Application verification function
# Return 0 if installed, 1 if not installed
Composer_Verify() {
    (( ! $(composer_Ready) )) && return 1

    composer -V > /dev/null 2>&1
    return $?
}
