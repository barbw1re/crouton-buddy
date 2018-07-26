#!/bin/bash

# Application display name
Kiki_App="Kiki Regular Expression Tester"

# Application install function
Kiki_Install() {
    sudo apt install -y kiki

    if [[ -f /usr/share/applications/kiki.desktop ]]; then
        sudo sed -i "s/Icon=.*/Icon=regexxer/g" /usr/share/applications/kiki.desktop
    fi
}

# Application verification function
# Return 0 if installed, 1 if not installed
Kiki_Verify() {
    [[ -f /usr/share/applications/kiki.desktop ]] && return 0 || return 1
}
