#!/bin/bash

# Application display name
MongoDb_App="MongoDB server"

# Application install function
MongoDb_Install() {
    local aptFile=/etc/apt/sources.list.d/mongodb-org-3.4.list

    if [[ ! -s "$aptFile" ]]; then
        sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 0C49F3730359A14518585931BC711F9BA15703C6
        sudo echo "deb [arch=amd64,arm64] http://repo.mongodb.org/apt/ubuntu xenial/mongodb-org/3.4 multiverse" | sudo tee "$aptFile"
        sudo apt update -y
    fi

    sudo apt install -y mongodb-org
}

# Application verification function
# Return 0 if installed, 1 if not installed
MongoDb_Verify() {
    # Verification steps
    return 1
}
