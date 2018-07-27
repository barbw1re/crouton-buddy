#!/bin/bash

################################################################
# Host (outside chroot) Menu
################################################################

# Set by caller:
#
# me       => full path to caller (crouton-buddy.sh script)
# CB_ROOT  => full path to Crouton Buddy application directory
# HOME_DIR => full path to home directory
# ROOT_DIR => full path to Downloads directory

# Globals
LINUX_RELEASE=""
DEFAULT_LINUX_RELEASE="xenial"

CHROOT_ROOT="/mnt/stateful_partition/crouton/chroots"

CROUTON_APP="$ROOT_DIR/crouton"
CROUTON_TARGETS="core,audio,x11,chrome,cli-extra,extension,gtk-extra,gnome,kde,keyboard,xorg,xiwi"

# Load dependencies
. "$CB_ROOT/cb-ui.sh"
. "$CB_ROOT/cb-crouton.sh"
. "$CB_ROOT/cb-common.sh"
. "$CB_ROOT/menu/bash-menu.sh"

#
# Menu item handlers
#
cbTest() {
    cbInitAction "Test this Action" || return 1

    cbEnsureRelease
    local release="$LINUX_RELEASE"

    cbAcknowledge "Release \"$release\" selected"

    return 1
}

cbCreate() {
    # Ensure needed globals:
    [[ "$CROUTON_APP"       ]] || cbAbort "CROUTON_APP not configured"
    [[ "$CROUTON_TARGETS"   ]] || cbAbort "CROUTON_TARGETS not configured"

    cbInitAction "Create a new environment" || return 1

    chrootName=`cbAsk "Enter name of new environment to create (or 'L' to list current environments): "`
    while [[ "$chrootName" && ( "$chrootName" = "l" || "$chrootName" = "L" || "$(cbIsChroot "$chrootName")" -eq 1 ) ]]; do
        echo ""
        if [[ "$chrootName" != "l" && "$chrootName" != "L" ]]; then
            cbError "There is already an environment named $chrootName"
        fi
        cbListChroots "Currently created environments:"
        chrootName=`cbAsk "Enter name of new environment to create (or '' to abort): "`
    done

    if [[ ! "$chrootName" ]]; then
        cbAcknowledgeAbort "Aborting environment creation."
        return 1
    fi

    echo ""

    # Make sure we ensure LINUX_RELEASE is set
    if [[ ! "$LINUX_RELEASE" ]]; then
        cbEnsureRelease
        echo ""
    fi

    if (( ! "$(cbConfirm "Are you sure you want to create new $LINUX_RELEASE environment $chrootName")" )); then
        cbAcknowledgeAbort "Aborting environment creation."
        return 1
    fi
    echo ""

    local bootstrap=`cbBootstrapFilename`
    cbEnsureBootstrap || return 1

    cbInfo "Creating installation of $LINUX_RELEASE as $chrootName" \
           "Using targets: $CROUTON_TARGETS"

    if (( ! "$(cbConfirm "Are you sure you want to create the new environment $chrootName")" )); then
        cbAcknowledgeAbort "Aborting environment creation."
        return 1
    fi

    # Finally - call Crouton to create new environment
    sudo sh $CROUTON_APP -n $chrootName -f $bootstrap -t $CROUTON_TARGETS

    cbAcknowledge "New environment $chrootName created."

    return 1
}

cbConfigure() {
    # Ensure needed globals:
    [[ "$me"          ]] || cbAbort "'me' not configured"
    [[ "$CHROOT_ROOT" ]] || cbAbort "CHROOT_ROOT not configured"

    cbInitAction "Configure/manage environment" || return 1

    if (( ! $(cbCountChroots) )); then
        cbAcknowledgeAbort "No environment found to manage."
        return 1
    fi

    cbListChroots
    chrootName=`cbAsk "Enter name of environment to manage: "`
    while [[ "$chrootName" && "$(cbIsChroot "$chrootName")" -eq 0 ]]; do
        echo ""
        cbError "There is no environment named $chrootName"
        cbListChroots
        chrootName=`cbAsk "Enter name of environment to manage (or '' to abort): "`
    done

    if [[ ! "$chrootName" ]]; then
        cbAcknowledgeAbort "Aborting environment management."
        return 1
    fi

    echo ""

    # Call Crouton to enter environment and execute crouton-buddy.sh script
    local chrootUser=`ls $CHROOT_ROOT/$chrootName/home/ | awk '{print $1}'`
    sudo enter-chroot -n $chrootName -l sh /home/$chrootUser/Downloads/$me

    return 1
}

cbEnter() {
    cbInitAction "Open terminal to environment" || return 1

    if (( ! $(cbCountChroots) )); then
        cbAcknowledgeAbort "No environment found to enter."
        return 1
    fi

    cbListChroots
    chrootName=`cbAsk "Enter name of environment to enter: "`
    while [[ "$chrootName" && "$(cbIsChroot "$chrootName")" -eq 0 ]]; do
        echo ""
        cbError "There is no environment named $chrootName"
        cbListChroots
        chrootName=`cbAsk "Enter name of environment to enter (or '' to abort): "`
    done

    if [[ ! "$chrootName" ]]; then
        cbAcknowledgeAbort "Aborting entering environment."
        return 1
    fi

    echo ""

    # Finally - call Crouton to enter environment
    sudo enter-chroot -n $chrootName

    return 1
}

cbStartGnome() {
    cbInitAction "Start Gnome environment" || return 1

    if (( ! $(cbCountChroots) )); then
        cbAcknowledgeAbort "No environment found to start."
        return 1
    fi

    cbListChroots
    chrootName=`cbAsk "Enter name of environment to start: "`
    while [[ "$chrootName" && "$(cbIsChroot "$chrootName")" -eq 0 ]]; do
        echo ""
        cbError "There is no environment named $chrootName"
        cbListChroots
        chrootName=`cbAsk "Enter name of environment to start (or '' to abort): "`
    done

    if [[ ! "$chrootName" ]]; then
        cbAcknowledgeAbort "Aborting starting environment."
        return 1
    fi

    echo ""

    # Finally - call Crouton to start gnome in background
    sudo startgnome -n $chrootName -b

    cbAcknowledge "Environment started. Logout of $chrootName to exit."

    return 1
}

cbStartKde() {
    cbInitAction "Start KDE environment" || return 1

    if (( ! $(cbCountChroots) )); then
        cbAcknowledgeAbort "No environment found to start."
        return 1
    fi

    cbListChroots
    chrootName=`cbAsk "Enter name of environment to start: "`
    while [[ "$chrootName" && "$(cbIsChroot "$chrootName")" -eq 0 ]]; do
        echo ""
        cbError "There is no environment named $chrootName"
        cbListChroots
        chrootName=`cbAsk "Enter name of environment to start (or '' to abort): "`
    done

    if [[ ! "$chrootName" ]]; then
        cbAcknowledgeAbort "Aborting starting environment."
        return 1
    fi

    echo ""

    # Finally - call Crouton to start KDE in background
    sudo startkde -n $chrootName -b

    cbAcknowledge "Environment started. Logout of $chrootName to exit."

    return 1
}

cbUpdate() {
    # Ensure needed globals:
    [[ "$CROUTON_APP" ]] || cbAbort "CROUTON_APP not configured"

    cbInitAction "Update an existing environment" || return 1

    if (( ! $(cbCountChroots) )); then
        cbAcknowledgeAbort "Nothing to update. No environments found."
        return 1
    fi

    cbListChroots
    chrootName=`cbAsk "Enter name of environment to update: "`
    while [[ "$chrootName" && "$(cbIsChroot "$chrootName")" -eq 0 ]]; do
        echo ""
        cbError "There is no environment named $chrootName"
        cbListChroots
        chrootName=`cbAsk "Enter name of environment to update (or '' to abort): "`
    done

    if [[ ! "$chrootName" ]]; then
        cbAcknowledgeAbort "Aborting environment update."
        return 1
    fi

    echo ""

    if (( ! "$(cbConfirm "Are you sure you want to update environment $chrootName")" )); then
        cbAcknowledgeAbort "Aborting environment update."
        return 1
    fi

    echo ""

    # Finally - call Crouton to update environment
    sudo sh $CROUTON_APP -n $chrootName -u

    cbAcknowledge "Environment updated."

    return 1
}

cbBackup() {
    cbInitAction "Backup environmewnt" || return 1

    if (( ! $(cbCountChroots) )); then
        cbAcknowledgeAbort "No environment found to backup."
        return 1
    fi

    cbListChroots
    chrootName=`cbAsk "Enter name of environment to backup: "`
    while [[ "$chrootName" && "$(cbIsChroot "$chrootName")" -eq 0 ]]; do
        echo ""
        cbError "There is no environment named $chrootName"
        cbListChroots
        chrootName=`cbAsk "Enter name of environment to backup (or '' to abort): "`
    done

    if [[ ! "$chrootName" ]]; then
        cbAcknowledgeAbort "Aborting environment backup."
        return 1
    fi

    echo ""
    if (( ! "$(cbConfirm "Are you sure you want to backup environment $chrootName")" )); then
        cbAcknowledgeAbort "Aborting environment backup."
        return 1
    fi

    echo ""

    # Finally - call Crouton to backup environment
    sudo edit-chroot -b $chrootName

    cbAcknowledge "Environment backup completed."

    return 1
}

cbRestore() {
    # Ensure needed globals:
    [[ "$ROOT_DIR" ]] || cbAbort "ROOT_DIR not configured"

    cbInitAction "Restore environment" || return 1

    if (( ! $(cbCountBackups) )); then
        cbAcknowledgeAbort "No backup files found to restore."
        return 1
    fi

    cbListBackups
    local backupFile=`cbAsk "Enter backup filename to restore: "`
    while [[ "$backupFile" && ! -f "$ROOT_DIR/$backupFile" ]]; do
        echo ""
        cbError "There is no backup file named $backupFile"
        cbListBackups
        backupFile=`cbAsk "Enter backup filename to restore (or '' to abort): "`
    done

    if [[ ! "$backupFile" ]]; then
        cbAcknowledgeAbort "Aborting environment restore."
        return 1
    fi

    echo ""

    if (( $(cbCountChroots) )); then
        cbListChroots
    fi
    chrootName=`cbAsk "Enter name of environment create via restore: "`

    if [[ ! "$chrootName" ]]; then
        cbAcknowledgeAbort "Aborting environment restore."
        return 1
    fi

    echo ""

    if [[ "$(cbIsChroot "$chrootName")" -eq 1 ]]; then
        if (( ! "$(cbConfirm "Are you sure you want to overwrite environment $chrootName with restore of $backupFile")" )); then
            cbAcknowledgeAbort "Aborting environment restore."
            return 1
        fi
        echo ""
        # Call Crouton to restore into existing environment
        sudo edit-chroot -rr $chrootName -f "$ROOT_DIR/$backupFile"
    else
        if (( ! "$(cbConfirm "Are you sure you want to create environment $chrootName via restore of $backupFile")" )); then
            cbAcknowledgeAbort "Aborting environment restore."
            return 1
        fi
        echo ""
        # Call Crouton to restore new environment
        sudo edit-chroot -r $chrootName -f "$ROOT_DIR/$backupFile"
    fi

    cbAcknowledge "Environment $chrootName restored."

    return 1
}

cbDelete() {
    cbInitAction "Delete environment" || return 1

    if (( ! $(cbCountChroots) )); then
        cbAcknowledgeAbort "No environment found to delete."
        return 1
    fi

    cbListChroots
    chrootName=`cbAsk "Enter name of environment to delete: "`
    while [[ "$chrootName" && "$(cbIsChroot "$chrootName")" -eq 0 ]]; do
        echo ""
        cbError "There is no environment named $chrootName"
        cbListChroots
        chrootName=`cbAsk "Enter name of environment to delete (or '' to abort): "`
    done

    if [[ ! "$chrootName" ]]; then
        cbAcknowledgeAbort "Aborting environment deletion."
        return 1
    fi

    echo ""
    if (( ! "$(cbConfirm "Are you sure you want to delete environment $chrootName")" )); then
        cbAcknowledgeAbort "Aborting environment deletion."
        return 1
    fi

    echo ""

    # Finally - call Crouton to delete environment
    sudo delete-chroot $chrootName

    cbAcknowledge "Environment deleted."

    return 1
}

cbPurge() {
    cbInitAction "Purge cached bootstrap" || return 1

    # Make sure we ensure LINUX_RELEASE is set first
    cbEnsureRelease

    local bootstrap=`cbBootstrapFilename`

    if [[ ! -s "$bootstrap" ]]; then
        cbAcknowledgeAbort "No cached bootstrap for $LINUX_RELEASE found (expected $bootstrap)"
        return 1
    fi

    if (( ! "$(cbConfirm "Are you sure you want to purge the cached $LINUX_RELEASE bootstrap")" )); then
        cbAcknowledgeAbort "Aborting bootstrap purge."
        return 1
    fi

    sudo rm "$bootstrap"
    local ret=$?

    if [[ $ret -ne 0 || -s "$bootstrap" ]]; then
        cbError "ERROR: Unable to purge $LINUX_RELEASE bootstrap"
        cbAcknowledge
        return 1
    fi

    cbAcknowledge "Bootstrap cache purged."

    return 1
}

cbConfigureGuests() {
    cbInitAction "Configure Crouton Guests" || return 1

    local release="$LINUX_RELEASE"
    LINUX_RELEASE=""

    cbEnsureRelease "$release"

    cbAcknowledge "Crouton Configured"

    return 1
}

################################################################
# Menu Setup
################################################################

# Menu item labels
menuItems=(
    "Test Action for Development    "
    "Create a new environment       "
    "Configure/manage environment   "
    "Enter an environment (terminal)"
    "Start an environment (Gnome)   "
    "Start an environment (KDE)     "
    "Update an existing environment "
    "Backup environment             "
    "Restore environment            "
    "Delete environment             "
    "Purge cached bootstrap         "
    "Configure Crouton Guests       "
    "Update Crouton Buddy scripts   "
    "Quit                           "
)

# Menu item action functions
menuActions=(
    cbTest
    cbCreate
    cbConfigure
    cbEnter
    cbStartGnome
    cbStartKde
    cbUpdate
    cbBackup
    cbRestore
    cbDelete
    cbPurge
    cbConfigureGuests
    cbInstall
    "return 0"
)

# Menu configuration overrides
menuTitle=" Crouton Administration"
menuWidth=60

################################################################
# Execute Script
################################################################
cbRun() {
    menuInit
    menuLoop
}
