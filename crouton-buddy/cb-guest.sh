#!/bin/bash

# Set by caller:
#
# #me       => full path to caller (crouton-buddy.sh script)
# CB_ROOT  => full path to Crouton Buddy application directory
# HOME_DIR => full path to home directory
# #ROOT_DIR => full path to Downloads directory

# Load dependencies
. "$CB_ROOT/cb-ui.sh"
. "$CB_ROOT/cb-crouton.sh"
. "$CB_ROOT/cb-common.sh"
. "$CB_ROOT/menu/bash-menu.sh"

declare -a cbPackages
cbPackages[Developer]="Git VsCode"

#
# Package Installer
#
cbInstaller() {
    local package="$1"

    cbStatus "Install $package package"

    for app in "${cbPackages[$pacakge]}" ; do
        cbInfo "$app"
        if [ "$(cbConfirm "Would you like to install $app")" -eq 1 ]; then
            # Install It
        fi
        echo ""
    done

    cbAcknowledge "$package package installed."

    return 1
}

#
# Menu item handlers
#
cbCoreSetup() {
    # Ensure needed globals:
    [[ "$HOME_DIR" != "" ]] || cbAbort "HOME_DIR not configured"

    cbStatus "Environment core setup"

    cbInfo "Installing package pre-requisites"
    sudo apt install -y software-properties-common language-pack-en-base curl apt-transport-https ca-certificates

    cbInfo "Installing common/core packages"
    sudo apt install -y whoopsie mlocate preload vim xarchiver p7zip p7zip-rar

    cbInfo "Getting up-to-date"
    sudo apt dist-upgrade -y

    cbInfo "Final environment cleanup"
    sudo chown -R 1000:1000 "$HOME_DIR"

    cbAcknowledge "Environment core setup complete."

    return 1
}

#
# Menu Setup
#
menuItems=(
    "Install common dependencies and core system applications"
    "Install Developer (general) package                     "
    "Quit                                                    "
)

menuActions=(
    cbCoreSetup
    "cbInstaller 'Developer'"
    "return 0"
)

#
# Menu Configuration
#
menuTitle=" Crouton Environment Manager"
menuWidth=80
menuHighlight=$DRAW_COL_BLUE

#
# Execute Script
#
cbRun() {
    menuInit
    menuLoop
}
