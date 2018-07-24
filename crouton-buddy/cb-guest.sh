#!/bin/bash

################################################################
# Guest (inside chroot) Menu
################################################################

# Set by caller:
#
# CB_ROOT  => full path to Crouton Buddy application directory
# HOME_DIR => full path to home directory

# Globals
APPS_ROOT="$CB_ROOT/apps"

# Load dependencies
. "$CB_ROOT/cb-ui.sh"
. "$CB_ROOT/cb-crouton.sh"
. "$CB_ROOT/cb-common.sh"
. "$CB_ROOT/menu/bash-menu.sh"

# Application bundles
declare -A cbPackages
cbPackages[Desktop]="Numix FileZilla"
cbPackages[Developer]="Git VsCode"

#
# Ensure we can find the associated installer script for the specified application
#
# Return full path to script, or "" if not found
#
cbVerifyApp() {
    # Ensure needed globals:
    [[ "$APPS_ROOT"    ]] || cbAbort "APPS_ROOT not configured"
    [[ -d "$APPS_ROOT" ]] || cbAbort "Unable to access APPS_ROOT"

    local app="$1"
    local appScript="$APPS_ROOT/$app.sh"

    [[ -s "$appScript" ]] && echo "$appScript" || echo ""
}

#
# Install the application associated with the provided name.
#
# This skips the install if the application is already installed.
# This will require the user confirm they want to install the application.
#
cbInstallApp() {
    local app="$1"
    local appScript=`cbVerifyApp "$app"`

    if [[ ! "$appScript" ]]; then
        cbError "Unable to find installation script for $app"
        return 1
    fi

    # Load app script
    . "$appScript"

    # App API
    eval name='$'"${app}_App"
    eval installer="${app}_Install"
    eval verifier="${app}_Verify"

    echo ""
    cbInfo "$name"
    echo ""

    $verifier
    if (( ! $? )); then
        cbWarning "$name is already installed"
        return 0
    fi

    if (( "$(cbConfirm "Would you like to install $name")" )); then
        echo ""
        $installer
        $verifier
        (( $? )) && cbAcknowledgeAbort "Failed to install $name"
    fi

    return 0
}

#
# Install all applications associated with the specified package/bundle.
# This will require a confirmation from the user before installing each application
# so they can be selective about which specific applications in the package thay want installed.
#
cbInstaller() {
    local package="$1"

    cbStatus "Install $package package"

    for app in ${cbPackages[$package]} ; do
        cbInstallApp "$app"
    done

    cbAcknowledge "$package package installed."

    return 1
}

################################################################
# Menu item handlers
################################################################

#
# Perform the core environment setup
#
cbCoreSetup() {
    # Ensure needed globals:
    [[ "$HOME_DIR" ]] || cbAbort "HOME_DIR not configured"

    cbStatus "Environment core setup"

    if (( ! "$(cbConfirm "Are you sure you want to install the core environment packages")" )); then
        cbAcknowledgeAbort "Aborting environment core setup."
        return 1
    fi

    echo ""
    cbInfo "Installing package pre-requisites"
    echo ""
    sudo apt install -y software-properties-common language-pack-en-base curl apt-transport-https ca-certificates

    echo ""
    cbInfo "Installing common/core packages"
    echo ""
    sudo apt install -y whoopsie mlocate preload vim xarchiver p7zip p7zip-rar

    echo ""
    cbInfo "Removing unwanted packages"
    echo ""
    sudo apt remove -y netsurf netsurf-common netsurf-fb netsurf-gtk

    echo ""
    cbInfo "Getting up-to-date"
    echo ""
    sudo apt dist-upgrade -y
    sudo apt autoremove -y

    echo ""
    cbInfo "Final environment cleanup"
    echo ""
    sudo chown -R 1000:1000 "$HOME_DIR"

    cbAcknowledge "Environment core setup complete."

    return 1
}

#
# Update and cleanup installed applications
#
cbCoreUpdate() {
    cbStatus "Update installed packages"

    if (( ! "$(cbConfirm "Are you sure you want to update all installed packages")" )); then
        cbAcknowledgeAbort "Aborting installation update."
        return 1
    fi

    echo ""
    cbInfo "Getting up-to-date"
    echo ""
    sudo apt update -y
    sudo apt dist-upgrade -y
    sudo apt autoremove -y

    cbAcknowledge "Installation update complete."

    return 1
}

#
# Install Gnome desktop
#
cbGnome() {
    cbStatus "Gnome Desktop Setup"

    if (( ! "$(cbConfirm "Are you sure you want to install the Gnome desktop")" )); then
        cbAcknowledgeAbort "Aborting Gnome desktop installation."
        return 1
    fi

    echo ""
    cbInfo "Configuring system for Gnome"
    echo ""
    sudo add-apt-repository -y ppa:gnome3-team/gnome3-staging
    sudo add-apt-repository -y ppa:gnome3-team/gnome3
    sudo apt update -y

    echo ""
    cbInfo "Installing Gnome desktop"
    echo ""
    sudo apt install -y gnome-tweak-tool gnome-terminal gnome-control-center gnome-online-accounts gnome-software gnome-software-common
    sudo apt install -y gnome-shell chrome-gnome-shell
    sudo apt install -y gnome-shell-extensions gnome-shell-extension-dashtodock gnome-shell-extension-taskbar gnome-shell-extensions-gpaste

    echo ""
    cbInfo "Removing replaced packages"
    echo ""
    sudo apt remove -y xterm
    sudo apt autoremove -y

    cbAcknowledge "Gnome dekstop installed."

    return 1
}

#
# Install KDE desktop
#
cbKde() {
    cbStatus "KDE Desktop Setup"

    if (( ! "$(cbConfirm "Are you sure you want to install the KDE desktop")" )); then
        cbAcknowledgeAbort "Aborting KDE desktop installation."
        return 1
    fi

    echo ""
    cbInfo "Configuring system for KDE"
    echo ""
    sudo add-apt-repository -y ppa:kubuntu-ppa/backports
    sudo apt update -y

    echo ""
    cbInfo "Installing Kubuntu desktop"
    echo ""
    sudo apt-get install -y kubuntu-desktop

    cbAcknowledge "KDE dekstop installed."

    return 1
}

################################################################
# Menu Setup
################################################################

# Menu item labels
menuItems=(
    "Install common dependencies and core system applications"
    "Update all installed packages                           "
    "Gnome desktop setup                                     "
    #"KDE desktop setup                                       "
    "Desktop (general) packages                              "
    "Common Developer packages                               "
)

# Menu item action functions
menuActions=(
    cbCoreSetup
    cbCoreUpdate
    cbGnome
    #cbKde
    'cbInstaller Desktop'
    'cbInstaller Developer'
)

# Menu configuration overrides
menuTitle=" Crouton Environment Manager"
menuWidth=80
menuHighlight=$DRAW_COL_BLUE

#
# Populate menu with available apps in apps/ directory
#
cbLoadMenu() {
    # @temporary: Disable this for now
    return

    if [[ -d "$APPS_ROOT" ]]; then
        for app in $APPS_ROOT/*.sh ; do
            local name=$(basename "$app" ".sh")
            # @todo: Pad menu item to correct width for menu
            menuItems+=( "$name" )
            menuActions+=( "cbInstallApp $name" )
        done
    fi
}

################################################################
# Execute Script
################################################################
cbRun() {
    # Add available apps to menu
    cbLoadMenu

    # Add Quit option to end of menu
    menuItems+=(
        "Quit                                                    "
    )
    menuActions+=("return 0")

    menuInit
    menuLoop
}
