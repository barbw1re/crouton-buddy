#!/bin/bash

# Constants
ROBO_MONGO_PATH=/usr/local/bin/robomongo
ROBO_MONGO_LAUNCHER_PATH=/usr/share/applications/robomongo.desktop

# Application display name
RoboMongo_App="RoboMongo database manager"

# Ensure dependencies
robomongo_Ready() {
    # @todo: Ensure we have MongoDB installed
    echo 1
    return 1
}

# Application install function
RoboMongo_Install() {
    if (( ! $(robomongo_Ready) )); then
        cbError "Missing Dependency: MongoDB"
        return
    fi

    # Install RoboMongo
    sudo apt install -y xcb

    cd /tmp
    wget "https://download.robomongo.org/1.1.1/linux/robo3t-1.1.1-linux-x86_64-c93c6b0.tar.gz" -O robomongo.tar.gz

    [[ -d "$ROBO_MONGO_PATH" ]] && sudo rm -rf "$ROBO_MONGO_PATH"

    sudo mkdir -p ${ROBO_MONGO_PATH}
    sudo tar xf robomongo.tar.gz
    sudo rm robomongo.tar.gz
    sudo mv robo3t-*/* ${ROBO_MONGO_PATH}
    sudo rm -rf robo3t-*/
    sudo rm ${ROBO_MONGO_PATH}/lib/libstdc++*
    sudo chmod +x ${ROBO_MONGO_PATH}/bin/robo3t

    sudo echo "[Desktop Entry]" > ${ROBO_MONGO_LAUNCHER_PATH}
    sudo echo "Name=Robomongo" >> ${ROBO_MONGO_LAUNCHER_PATH}
    sudo echo "Comment=MongoDB Database Administration" >> ${ROBO_MONGO_LAUNCHER_PATH}
    sudo echo "Exec=/usr/local/bin/robomongo/bin/robo3t" >> ${ROBO_MONGO_LAUNCHER_PATH}
    sudo echo "Terminal=false" >> ${ROBO_MONGO_LAUNCHER_PATH}
    sudo echo "Type=Application" >> ${ROBO_MONGO_LAUNCHER_PATH}
    sudo echo "Icon=robomongo" >> ${ROBO_MONGO_LAUNCHER_PATH}
    sudo echo "StartupWMClass=robo3t" >> ${ROBO_MONGO_LAUNCHER_PATH}
}

# Application verification function
# Return 0 if installed, 1 if not installed
RoboMongo_Verify() {
    (( ! $(robomongo_Ready) )) && return 1

    if [[ -d $ROBO_MONGO_PATH && -s $ROBO_MONGO_LAUNCHER_PATH ]]; then
        return 0
    fi

    return 1
}
