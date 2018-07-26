#!/bin/bash

# Application display name
Stacer_App="Stacer System Optimizer and Monitor"

# Application install function
Stacer_Install() {
    cd /tmp
    wget "https://github.com/oguzhaninan/Stacer/releases/download/v1.0.8/Stacer_1.0.8_amd64.deb" -O stacer.deb
    sudo dpkg -i stacer.deb
    sudo rm stacer.deb
}

# Application verification function
# Return 0 if installed, 1 if not installed
Stacer_Verify() {
    [[ "`which stacer 2> /dev/null`" ]] && return 0 || return 1
}
