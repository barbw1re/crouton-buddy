#!/bin/bash

# Application display name
NodeJS_App="NodeJS v9.0"

# Application install function
NodeJS_Install() {
    curl -sL "https://deb.nodesource.com/setup_9.x" | sudo -E bash -
    sudo apt install -y build-essential nodejs
}

# Application verification function
# Return 0 if installed, 1 if not installed
NodeJS_Verify() {
    npm -v > /dev/null 2>&1
    return $?
}
