#!/bin/bash

# Application display name
Insomnia_App="Insomnia REST Client"

# Application install function
Insomnia_Install() {
    cd /tmp
    wget "https://builds.insomnia.rest/downloads/ubuntu/latest" -O insomnia.deb
    sudo dpkg -i insomnia.deb
    sudo rm insomnia.deb
}

# Application verification function
# Return 0 if installed, 1 if not installed
Insomnia_Verify() {
    [[ "`which insomnia 2> /dev/null`" ]] && return 0 || return 1
}
