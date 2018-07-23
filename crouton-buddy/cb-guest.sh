#!/bin/bash

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

declare -A cbPackages
cbPackages[Desktop]="Numix FileZilla"
cbPackages[Developer]="Git VsCode"

#
# Helpers
#
cbVerifyApp() {
    # Ensure needed globals:
    [[ "$APPS_ROOT" != "" ]] || cbAbort "APPS_ROOT not configured"
    [[ -d "$APPS_ROOT"    ]] || cbAbort "Unable to access APPS_ROOT"

    local app="$1"
    local appScript="$APPS_ROOT/$app.sh"

    [[ -s "$appScript" ]] && echo "$appScript" || echo ""
}

#
# Package Installer
#
cbInstallApp() {
    local app="$1"
    local appScript=`cbVerifyApp "$app"`

    if [[ "$appScript" = "" ]]; then
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
    if [[ $? -eq 0 ]]; then
        cbWarning "$name is already installed"
        return 0
    fi

    if [[ "$(cbConfirm "Would you like to install $name")" -eq 1 ]]; then
        echo ""
        $installer
        $verifier
        if [[ $? -eq 1 ]]; then
            cbAcknowledgeAbort "Failed to install $name"
        fi
    fi

    return 0
}

cbInstaller() {
    local package="$1"

    cbStatus "Install $package package"

    for app in ${cbPackages[$package]} ; do
        cbInstallApp "$app"
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

    if [[ "$(cbConfirm "Are you sure you want to install the core environment packages")" -eq 0 ]]; then
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

cbGnome() {
    cbStatus "Gnome Desktop Setup"

    if [[ "$(cbConfirm "Are you sure you want to install the Gnome desktop")" -eq 0 ]]; then
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

    cbAcknowledge "Gnome dekstop installed."

    return 1
}

cbKde() {
    cbStatus "KDE Desktop Setup"

    if [[ "$(cbConfirm "Are you sure you want to install the KDE desktop")" -eq 0 ]]; then
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

#
# Menu Setup
#
menuItems=(
    "Install common dependencies and core system applications"
    "Gnome desktop setup                                     "
    #"KDE desktop setup                                       "
    "Desktop (general) packages                              "
    "Common Developer packages                               "
)

menuActions=(
    cbCoreSetup
    cbGnome
    #cbKde
    'cbInstaller Desktop'
    'cbInstaller Developer'
)

#
# Menu Configuration
#
menuTitle=" Crouton Environment Manager"
menuWidth=80
menuHighlight=$DRAW_COL_BLUE

#
# Populate menu with available apps
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

#
# Execute Script
#
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
