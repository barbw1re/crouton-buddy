#!/bin/bash

# Constants
POPCORN_TIME_LAUNCHER_PATH=/usr/share/applications/popcorntime.desktop

# Application display name
PopcornTime_App="Popcorn Time"

# Application install function
PopcornTime_Install() {
    [[ -d /opt/popcorn-time ]] && sudo rm -rf /opt/popcorn-time/

    sudo mkdir /opt/popcorn-time
    sudo wget -qO- "https://get.popcorntime.sh/build/Popcorn-Time-0.3.10-Linux-64.tar.xz" | sudo tar Jx -C /opt/popcorn-time
    sudo ln -sf /opt/popcorn-time/Popcorn-Time /usr/bin/popcorn-time

    sudo echo "[Desktop Entry]" > ${POPCORN_TIME_LAUNCHER_PATH}
    sudo echo "Version=1.0" >> ${POPCORN_TIME_LAUNCHER_PATH}
    sudo echo "Terminal=false" >> ${POPCORN_TIME_LAUNCHER_PATH}
    sudo echo "Type=Application" >> ${POPCORN_TIME_LAUNCHER_PATH}
    sudo echo "Name=Popcorn Time" >> ${POPCORN_TIME_LAUNCHER_PATH}
    sudo echo "Icon=popcorntime" >> ${POPCORN_TIME_LAUNCHER_PATH}
    sudo echo "Exec=/opt/popcorn-time/Popcorn-Time" >> ${POPCORN_TIME_LAUNCHER_PATH}
    sudo echo "StartupWMClass=Chromium-browser" >> ${POPCORN_TIME_LAUNCHER_PATH}
    sudo echo "Categories=Application;" >> ${POPCORN_TIME_LAUNCHER_PATH}
}

# Application verification function
# Return 0 if installed, 1 if not installed
PopcornTime_Verify() {
    if [[ -d /opt/popcorn-time && -s $POPCORN_TIME_LAUNCHER_PATH ]]; then
        return 0
    fi
    return 1
}
