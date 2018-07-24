#!/bin/bash

Numix_App="Numix Desktop Theme"

Numix_Install() {
    sudo add-apt-repository -y ppa:numix/ppa
    sudo apt update -y

    sudo apt install -y numix-gtk-theme numix-icon-theme-circle
}

Numix_Verify() {
    [[ -d "/usr/share/doc/numix-icon-theme-circle" ]] && return 0 || return 1
}
