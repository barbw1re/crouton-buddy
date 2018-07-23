#!/bin/bash

# Set by caller:
#
# me       => full path to caller (crouton-buddy.sh script)
# CB_ROOT  => full path to Crouton Buddy application directory
# HOME_DIR => full path to home directory
# ROOT_DIR => full path to Downloads directory

# Globals
LINUX_RELEASE="xenial"
CHROOT_ROOT="/mnt/stateful_partition/crouton/chroots"
CROUTON_APP="$ROOT_DIR/crouton"
CROUTON_BOOTSTRAP="$ROOT_DIR/$LINUX_RELEASE.tar.bz2"
CROUTON_TARGETS="core,audio,x11,chrome,cli-extra,extension,gtk-extra,gnome,keyboard,xorg,xiwi"

# Load dependencies
. "$CB_ROOT/cb-ui.sh"
. "$CB_ROOT/cb-crouton.sh"
. "$CB_ROOT/cb-common.sh"
. "$CB_ROOT/menu/bash-menu.sh"

#
# Menu item handlers
#
cbCreate() {
    # Ensure needed globals:
    [[ "$CROUTON_APP"       != "" ]] || cbAbort "CROUTON_APP not configured"
    [[ "$CROUTON_BOOTSTRAP" != "" ]] || cbAbort "CROUTON_BOOTSTRAP not configured"
    [[ "$CROUTON_TARGETS"   != "" ]] || cbAbort "CROUTON_TARGETS not configured"
    [[ "$LINUX_RELEASE"     != "" ]] || cbAbort "LINUX_RELEASE not configured"

    cbInitAction "Create a new environment" || return 1

    CHROOT_NAME=`cbAsk "Enter name of new environment to create (or 'L' to list current environments): "`
    while [[ "$CHROOT_NAME" != "" && ( "$CHROOT_NAME" = "l" || "$CHROOT_NAME" = "L" || "$(cbIsChroot "$CHROOT_NAME")" -eq 1 ) ]]; do
        echo ""
        if [[ "$CHROOT_NAME" != "l" && "$CHROOT_NAME" != "L" ]]; then
            cbError "There is already an environment named $CHROOT_NAME"
        fi
        cbListChroots "Currently created environments:"
        CHROOT_NAME=`cbAsk "Enter name of new environment to create (or '' to abort): "`
    done

    if [[ "$CHROOT_NAME" = "" ]]; then
        cbAcknowledgeAbort "Aborting environment creation."
        return 1
    fi

    echo ""
    if [[ "$(cbConfirm "Are you sure you want to create new environment $CHROOT_NAME")" -eq 0 ]]; then
        cbAcknowledgeAbort "Aborting environment creation."
        return 1
    fi
    echo ""

    cbEnsureBootstrap || return 1

    cbInfo "Creating installation of $LINUX_RELEASE as $CHROOT_NAME" \
           "Using targets: $CROUTON_TARGETS"

    if [[ "$(cbConfirm "Are you sure you want to create the new environment $CHROOT_NAME")" -eq 0 ]]; then
        cbAcknowledgeAbort "Aborting environment creation."
        return 1
    fi

    # Finally - call Crouton to create new environment
    sudo sh $CROUTON_APP -n $CHROOT_NAME -f $CROUTON_BOOTSTRAP -t $CROUTON_TARGETS

    cbAcknowledge "New environment $CHROOT_NAME created."

    return 1
}

cbEnter() {
    cbInitAction "Open terminal to environment" || return 1

    if [[ $(cbCountChroots) -eq 0 ]]; then
        cbAcknowledgeAbort "No environment found to enter."
        return 1
    fi

    cbListChroots
    CHROOT_NAME=`cbAsk "Enter name of environment to enter: "`
    while [[ "$CHROOT_NAME" != "" && "$(cbIsChroot "$CHROOT_NAME")" -eq 0 ]]; do
        echo ""
        cbError "There is no environment named $CHROOT_NAME"
        cbListChroots
        CHROOT_NAME=`cbAsk "Enter name of environment to enter (or '' to abort): "`
    done

    if [[ "$CHROOT_NAME" = "" ]]; then
        cbAcknowledgeAbort "Aborting entering environment."
        return 1
    fi

    echo ""

    # Finally - call Crouton to enter environment
    sudo enter-chroot -n $CHROOT_NAME

    cbAcknowledge "Back from environment $CHROOT_NAME"

    return 1
}

cbStartGnome() {
    cbInitAction "Start Gnome environment" || return 1

    if [[ $(cbCountChroots) -eq 0 ]]; then
        cbAcknowledgeAbort "No environment found to start."
        return 1
    fi

    cbListChroots
    CHROOT_NAME=`cbAsk "Enter name of environment to start: "`
    while [[ "$CHROOT_NAME" != "" && "$(cbIsChroot "$CHROOT_NAME")" -eq 0 ]]; do
        echo ""
        cbError "There is no environment named $CHROOT_NAME"
        cbListChroots
        CHROOT_NAME=`cbAsk "Enter name of environment to start (or '' to abort): "`
    done

    if [[ "$CHROOT_NAME" = "" ]]; then
        cbAcknowledgeAbort "Aborting starting environment."
        return 1
    fi

    echo ""

    # Finally - call Crouton to start gnome in background
    sudo startgnome -n $CHROOT_NAME -b

    cbAcknowledge "Environment started. Logout of $CHROOT_NAME to exit."

    return 1
}

cbStartKde() {
    cbInitAction "Start KDE environment" || return 1

    if [[ $(cbCountChroots) -eq 0 ]]; then
        cbAcknowledgeAbort "No environment found to start."
        return 1
    fi

    cbListChroots
    CHROOT_NAME=`cbAsk "Enter name of environment to start: "`
    while [[ "$CHROOT_NAME" != "" && "$(cbIsChroot "$CHROOT_NAME")" -eq 0 ]]; do
        echo ""
        cbError "There is no environment named $CHROOT_NAME"
        cbListChroots
        CHROOT_NAME=`cbAsk "Enter name of environment to start (or '' to abort): "`
    done

    if [[ "$CHROOT_NAME" = "" ]]; then
        cbAcknowledgeAbort "Aborting starting environment."
        return 1
    fi

    echo ""

    # Finally - call Crouton to start KDE in background
    sudo startkde -n $CHROOT_NAME -b

    cbAcknowledge "Environment started. Logout of $CHROOT_NAME to exit."

    return 1
}

cbUpdate() {
    # Ensure needed globals:
    [[ "$CROUTON_APP" != "" ]] || cbAbort "CROUTON_APP not configured"

    cbInitAction "Update an existing environment" || return 1

    if [[ $(cbCountChroots) -eq 0 ]]; then
        cbAcknowledgeAbort "Nothing to update. No environments found."
        return 1
    fi

    cbListChroots
    CHROOT_NAME=`cbAsk "Enter name of environment to update: "`
    while [[ "$CHROOT_NAME" != "" && "$(cbIsChroot "$CHROOT_NAME")" -eq 0 ]]; do
        echo ""
        cbError "There is no environment named $CHROOT_NAME"
        cbListChroots
        CHROOT_NAME=`cbAsk "Enter name of environment to update (or '' to abort): "`
    done

    if [[ "$CHROOT_NAME" = "" ]]; then
        cbAcknowledgeAbort "Aborting environment update."
        return 1
    fi

    echo ""
    if [[ "$(cbConfirm "Are you sure you want to update environment $CHROOT_NAME")" -eq 0 ]]; then
        cbAcknowledgeAbort "Aborting environment update."
        return 1
    fi

    # Finally - call Crouton to update environment
    sudo sh $CROUTON_APP -n $CHROOT_NAME -u

    cbAcknowledge "Environment updated."

    return 1
}

cbConfigure() {
    # Ensure needed globals:
    [[ "$me"          != "" ]] || cbAbort "'me' not configured"
    [[ "$CHROOT_ROOT" != "" ]] || cbAbort "CHROOT_ROOT not configured"

    cbInitAction "Configure/manage environment" || return 1

    if [[ $(cbCountChroots) -eq 0 ]]; then
        cbAcknowledgeAbort "No environment found to manage."
        return 1
    fi

    cbListChroots
    CHROOT_NAME=`cbAsk "Enter name of environment to manage: "`
    while [[ "$CHROOT_NAME" != "" && "$(cbIsChroot "$CHROOT_NAME")" -eq 0 ]]; do
        echo ""
        cbError "There is no environment named $CHROOT_NAME"
        cbListChroots
        CHROOT_NAME=`cbAsk "Enter name of environment to manage (or '' to abort): "`
    done

    if [[ "$CHROOT_NAME" = "" ]]; then
        cbAcknowledgeAbort "Aborting environment management."
        return 1
    fi

    echo ""

    # Call Crouton to enter environment and execute crouton-buddy.sh script
    local chrootUser=`ls $CHROOT_ROOT/$CHROOT_NAME/home/ | awk '{print $1}'`
    sudo enter-chroot -n $CHROOT_NAME -l sh /home/$chrootUser/Downloads/$me

    return 1
}

cbBackup() {
    cbInitAction "Backup environmewnt" || return 1

    if [[ $(cbCountChroots) -eq 0 ]]; then
        cbAcknowledgeAbort "No environment found to backup."
        return 1
    fi

    cbListChroots
    CHROOT_NAME=`cbAsk "Enter name of environment to backup: "`
    while [[ "$CHROOT_NAME" != "" && "$(cbIsChroot "$CHROOT_NAME")" -eq 0 ]]; do
        echo ""
        cbError "There is no environment named $CHROOT_NAME"
        cbListChroots
        CHROOT_NAME=`cbAsk "Enter name of environment to backup (or '' to abort): "`
    done

    if [[ "$CHROOT_NAME" = "" ]]; then
        cbAcknowledgeAbort "Aborting environment backup."
        return 1
    fi

    echo ""
    if [[ "$(cbConfirm "Are you sure you want to backup environment $CHROOT_NAME")" -eq 0 ]]; then
        cbAcknowledgeAbort "Aborting environment backup."
        return 1
    fi

    # Finally - call Crouton to backup environment
    sudo edit-chroot -b $CHROOT_NAME

    cbAcknowledge "Environment backup completed."

    return 1
}

cbRestore() {
    cbInitAction "Restore environment" || return 1

    #   Pick backup file from $CROUTON_ROOT
    #       *** Can we restore specific version? ***
    #       or notify abort action + get acknowledgement

    if [[ $(cbCountChroots) -gt 0 ]]; then
        cbListChroots
    fi
    CHROOT_NAME=`cbAsk "Enter name of environment create via restore: "`

    if [[ "$CHROOT_NAME" = "" ]]; then
        cbAcknowledgeAbort "Aborting environment restore."
        return 1
    fi

    echo ""

    if [[ "$(cbIsChroot "$CHROOT_NAME")" -eq 1 ]]; then
        if [ "$(cbConfirm "Are you sure you want to overwrite environment $CHROOT_NAME with restore of XXXX")" -eq 0 ]; then
            cbAcknowledgeAbort "Aborting environment restore."
            return 1
        fi
        # Call Crouton to restore into existing environment
        sudo edit-chroot -rr $CHROOT_NAME
    else
        if [[ "$(cbConfirm "Are you sure you want to create environment $CHROOT_NAME via restore of XXXX")" -eq 0 ]]; then
            cbAcknowledgeAbort "Aborting environment restore."
            return 1
        fi
        # Call Crouton to restore new environment
        sudo edit-chroot -r $CHROOT_NAME
    fi

    cbAcknowledge "Environment created via restore."

    return 1
}

cbDelete() {
    cbInitAction "Delete environment" || return 1

    if [[ $(cbCountChroots) -eq 0 ]]; then
        cbAcknowledgeAbort "No environment found to delete."
        return 1
    fi

    cbListChroots
    CHROOT_NAME=`cbAsk "Enter name of environment to delete: "`
    while [[ "$CHROOT_NAME" != "" && "$(cbIsChroot "$CHROOT_NAME")" -eq 0 ]]; do
        echo ""
        cbError "There is no environment named $CHROOT_NAME"
        cbListChroots
        CHROOT_NAME=`cbAsk "Enter name of environment to delete (or '' to abort): "`
    done

    if [[ "$CHROOT_NAME" = "" ]]; then
        cbAcknowledgeAbort "Aborting environment deletion."
        return 1
    fi

    echo ""
    if [[ "$(cbConfirm "Are you sure you want to delete environment $CHROOT_NAME")" -eq 0 ]]; then
        cbAcknowledgeAbort "Aborting environment deletion."
        return 1
    fi

    # Finally - call Crouton to delete environment
    sudo delete-chroot $CHROOT_NAME

    cbAcknowledge "Environment deleted."

    return 1
}

cbPurge() {
    # Ensure needed globals:
    [[ "$CROUTON_BOOTSTRAP" != "" ]] || cbAbort "CROUTON_BOOTSTRAP not configured"
    [[ "$LINUX_RELEASE"     != "" ]] || cbAbort "LINUX_RELEASE not configured"

    cbInitAction "Purge cached bootstrap" || return 1

    if [[ ! -s "$CROUTON_BOOTSTRAP" ]]; then
        cbAcknowledgeAbort "No cached bootstrap for $LINUX_RELEASE found (expected $CROUTON_BOOTSTRAP)"
        return 1
    fi

    if [[ "$(cbConfirm "Are you sure you want to purge the cached $LINUX_RELEASE bootstrap")" -eq 0 ]]; then
        cbAcknowledgeAbort "Aborting bootstrap purge."
        return 1
    fi

    sudo rm "$CROUTON_BOOTSTRAP"
    local ret=$?

    if [[ $ret -ne 0 || -s "$CROUTON_BOOTSTRAP" ]]; then
        cbError "ERROR: Unable to purge $LINUX_RELEASE bootstrap"
        cbAcknowledge
        return 1
    fi

    cbAcknowledge "Bootstrap cache purged."

    return 1
}

#
# Menu Setup
#
menuItems=(
    "Create a new environment       "
    "Enter an environment (terminal)"
    "Start an environment (Gnome)   "
    "Start an environment (KDE)     "
    "Update an existing environment "
    "Configure/manage environment   "
    "Backup environmewnt            "
    "Restore environment            "
    "Delete environment             "
    "Purge cached bootstrap         "
    "Quit                           "
)

menuActions=(
    cbCreate
    cbEnter
    cbStartGnome
    cbStartKde
    cbUpdate
    cbConfigure
    cbBackup
    cbRestore
    cbDelete
    cbPurge
    "return 0"
)

#
# Menu Configuration
#
menuTitle=" Crouton Administration"
menuWidth=60

#
# Execute Script
#
cbRun() {
    menuInit
    menuLoop
}
