#!/bin/bash

# Application display name
FacebookMessenger_App="Facebook Messenger"

# Application install function
FacebookMessenger_Install() {
    cd /tmp
    wget "https://updates.messengerfordesktop.com/download/linux/latest/beta?arch=amd64&pkg=deb" -O messenger.deb
    sudo dpkg -i messenger.deb
    sudo rm messenger.deb
}

# Application verification function
# Return 0 if installed, 1 if not installed
FacebookMessenger_Verify() {
    # @todo: Determine correct verification
    return 0
}
