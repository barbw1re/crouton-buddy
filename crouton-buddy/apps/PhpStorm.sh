#!/bin/bash

# Constants
PHPSTORM_PATH=/usr/local/bin/phpstorm
PHPSTORM_LAUNCHER_PATH=/usr/share/applications/phpstorm.desktop

# Application display name
PhpStorm_App="PHP Storm (30 day trial) IDE"

# Application install function
PhpStorm_Install() {
    cd /tmp
    wget "https://download.jetbrains.com/webide/PhpStorm-2017.3.4.tar.gz" -O phpstorm.tar.gz
    sudo tar xf phpstorm.tar.gz

    [[ -d ${PHPSTORM_PATH} ]] && sudo rm -rf ${PHPSTORM_PATH}

    sudo mkdir -p ${PHPSTORM_PATH}
    sudo mv PhpStorm-*/* ${PHPSTORM_PATH}
    sudo rm -rf PhpStorm-*/
    sudo rm phpstorm.tar.gz

    sudo echo "[Desktop Entry]" > ${PHPSTORM_LAUNCHER_PATH}
    sudo echo "Version=1.0" >> ${PHPSTORM_LAUNCHER_PATH}
    sudo echo "Type=Application" >> ${PHPSTORM_LAUNCHER_PATH}
    sudo echo "Name=PhpStorm" >> ${PHPSTORM_LAUNCHER_PATH}
    sudo echo "Icon=phpstorm" >> ${PHPSTORM_LAUNCHER_PATH}
    sudo echo "Exec=/usr/local/bin/phpstorm/bin/phpstorm.sh" >> ${PHPSTORM_LAUNCHER_PATH}
    sudo echo "StartupWMClass=jetbrains-phpstorm" >> ${PHPSTORM_LAUNCHER_PATH}
    sudo echo "Comment=The Drive to Develop" >> ${PHPSTORM_LAUNCHER_PATH}
    sudo echo "Categories=Development;IDE;" >> ${PHPSTORM_LAUNCHER_PATH}
    sudo echo "Terminal=false" >> ${PHPSTORM_LAUNCHER_PATH}
}

# Application verification function
# Return 0 if installed, 1 if not installed
PhpStorm_Verify() {
    if [[ -d $PHPSTORM_PATH && -s $PHPSTORM_LAUNCHER_PATH ]]; then
        return 0
    fi
    return 1
}
