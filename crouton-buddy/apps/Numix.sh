#!/bin/bash

# Application display name
Numix_App="Numix Desktop Theme"

# Application install function
Numix_Install() {
    sudo add-apt-repository -y ppa:numix/ppa
    sudo apt update -y

    sudo apt install -y numix-gtk-theme numix-icon-theme-circle
}

# Application verification function
# Return 0 if installed, 1 if not installed
Numix_Verify() {
    [[ -d "/usr/share/doc/numix-icon-theme-circle" ]] && return 0 || return 1
}
