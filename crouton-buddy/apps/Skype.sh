#!/bin/bash

# Application display name
Skype_App="Skype messenger"

# Application install function
Skype_Install() {
    cd /tmp
    wget "https://go.skype.com/skypeforlinux-64.deb" -O skypeforlinux.deb
    sudo dpkg -i skypeforlinux.deb
    sudo rm skypeforlinux.deb
}

# Application verification function
# Return 0 if installed, 1 if not installed
Skype_Verify() {
    # Verification steps
    return 1
}
