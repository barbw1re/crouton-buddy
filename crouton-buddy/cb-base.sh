#!/bin/bash

cbDir=`pwd`
cd $(dirname "$0")
cbDir=`pwd`
cd "$cbDir"

# Globals
HOME_DIR="/home/chronos/user"   # @placeholder: Should be set by caller
LINUX_RELEASE="xenial"
CROUTON_APP="$bin/crouton"
CROUTON_ROOT="$HOME_DIR/Downloads"
CROUTON_BOOTSTRAP="$CROUTON_ROOT/$LINUX_RELEASE.tar.bz2"
CROUTON_TARGETS="core,audio,x11,chrome,cli-extra,extension,gtk-extra,gnome,keyboard,xorg,xiwi"
CHROOT_ROOT="/mnt/stateful_partition/crouton/chroots"

# Load dependencies
. "$cbDir/cb-ui.sh"
. "$cbDir/cb-crouton.sh"
. "$cbDir/menu/bash-menu.sh"


#
# Helpers
#

#
# Ensure setup and display action banner
cbInitAction() {
    cbStatus "$*"
    if [ "$(cbEnsureCrouton)" -eq 0 ]; then
        cbError "ERROR: Unable to access (or download) crouton installer"
        return 0
    fi
    return 1
}


#
# Menu item handlers
#
cbCreate() {
    # @needs:
    #   $LINUX_RELEASE      => xenial
    #   $HOME_DIR           => /home/chronos/user -or- /home/`ls /home/ | awk '{print $1}'`
    #   $CROUTON_ROOT       => $HOME_DIR/Downloads
    #   $CROUTON_BOOTSTRAP  => $CROUTON_ROOT/$LINUX_RELEASE.tar.bz2
    #   $CROUTON_TARGETS    => core,audio,x11,chrome,cli-extra,extension,gtk-extra,gnome,keyboard,xorg,xiwi
    #   $bin                => Directory of calling script (Downloads directory)
    #   $CROUTON_APP        => $bin/crouton
    #
    # @steps:
    cbInitAction "Create a new environment"
    #   Do:
    #       **MAYBE** List environments
    #       Enter environment (into $CHROOT_NAME)
    #           or notify abort action + get acknowledgement
    #   While exists environmewnt $CHROOT_NAME
    CHROOT_NAME="PLACEHOLDER"
    if [ "$(cbConfirm "Are you sure you want to create new environment $CHROOT_NAME")" -eq 0 ]; then
        cbAcknowledge "Aborting environment creation."
        return 1
    fi
    #   Ensure bootstrap
    #       Ensure file $CROUTON_BOOTSTRAP
    #           or:
    #               Notify bootstrap download for $LINUX_RELEASE
    #               sudo sh $CROUTON_APP -d -f $CROUTON_BOOTSTRAP -r $LINUX_RELEASE -t $CROUTON_TARGETS
    #       Ensure file $CROUTON_BOOTSTRAP (to verify)
    #           or notify abort action + get acknowledgement
    #   Notify creating installation of $LINUX_RELEASE as $CHROOT_NAME
    #   Notify using $CROUTON_TARGETS
    CHROOT_NAME="PLACEHOLDER"
    if [ "$(cbConfirm "Are you sure you want to create the new environment $CHROOT_NAME")" -eq 0 ]; then
        cbAcknowledge "Aborting environment creation."
        return 1
    fi
    #   sudo sh $CROUTON_APP -n $CHROOT_NAME -f $CROUTON_BOOTSTRAP -t $CROUTON_TARGETS
    cbAcknowledge "New environment created."

    return 1
}

cbUpdate() {
    # @needs:
    #   $bin                => Directory of calling script (Downloads directory)
    #   $CROUTON_APP        => $bin/crouton
    #
    # @steps:
    cbInitAction "Update an existing environment"
    #   Pick existing environment (into $CHROOT_NAME)
    #       or notify abort action + get acknowledgement
    CHROOT_NAME="PLACEHOLDER"
    if [ "$(cbConfirm "Are you sure you want to update environment $CHROOT_NAME")" -eq 0 ]; then
        cbAcknowledge "Aborting environment update."
        return 1
    fi
    #   sudo sh $CROUTON_APP -n $CHROOT_NAME -u
    cbAcknowledge "Environment updated."

    return 1
}

cbEnter() {
    # @needs:
    #   $me                 => Calling script in Downloads directory (crouton-buddy.sh)
    #   $CHROOT_ROOT        => /mnt/stateful_partition/crouton/chroots
    #
    # @steps:
    cbInitAction "Enter and configure/manage environment"
    #   Pick existing environment (into $CHROOT_NAME)
    #       or notify abort action + get acknowledgement
    #   CHROOT_DIR="$CHROOT_ROOT/$CHROOT_NAME"
    #   CHROOT_USER=`ls $CHROOT_DIR/home/ | awk '{print $1}'`
    #   sudo enter-chroot -n $CHROOT_NAME -l sh /home/$CHROOT_USER/Downloads/$me
    #   **MAYBE**: Notify success + get acknowledgement

    # @placeholder:
    $cbDir/test-chroot.sh

    return 1
}

cbBackup() {
    # @needs:
    #   Nothing
    #
    # @steps:
    cbInitAction "Backup environmewnt"
    #   Require at least 1 environment
    #       or notify abort action + get acknowledgement
    #   Pick existing environment (into $CHROOT_NAME)
    #       or notify abort action + get acknowledgement
    CHROOT_NAME="PLACEHOLDER"
    if [ "$(cbConfirm "Are you sure you want to backup environment $CHROOT_NAME")" -eq 0 ]; then
        cbAcknowledge "Aborting environment backup."
        return 1
    fi
    #   sudo edit-chroot -b $CHROOT_NAME
    cbAcknowledge "Environment backup completed."

    return 1
}

cbRestore() {
    # @needs:
    #   $CROUTON_ROOT       => $HOME_DIR/Downloads
    #
    # @steps:
    cbInitAction "Restore environment"
    #   Pick backup file from $CROUTON_ROOT
    #       *** Can we restore specific version? ***
    #       or notify abort action + get acknowledgement
    #   Pick or enter environment (into $CHROOT_NAME)
    #       *** Determine name from file and pre-fill picker ***
    #       or notify abort action + get acknowledgement
    #   If exists $CHROOT_NAME:
    CHROOT_NAME="PLACEHOLDER"
    if [ "$(cbConfirm "Are you sure you want to overwrite environment $CHROOT_NAME with restore of XXXX")" -eq 0 ]; then
        cbAcknowledge "Aborting environment restore."
        return 1
    fi
    #       sudo edit-chroot -rr $CHROOT_NAME
    #   Else:
    CHROOT_NAME="PLACEHOLDER"
    if [ "$(cbConfirm "Are you sure you want to create environment $CHROOT_NAME via restore of XXXX")" -eq 0 ]; then
        cbAcknowledge "Aborting environment restore."
        return 1
    fi
    #       sudo edit-chroot -r $CHROOT_NAME
    #   **MAYBE**: Notify success + get acknowledgement

    # @placeholder:
    echo "Creating new environment via restore"
    echo " - or -"
    echo "Replacing environment with restore"
    cbAcknowledge

    return 1
}

cbDelete() {
    # @needs:
    #   Nothing
    #
    # @steps:
    cbInitAction "Delete environment"
    #   Pick existing environment (into $CHROOT_NAME)
    #       or notify abort action + get acknowledgement
    CHROOT_NAME="PLACEHOLDER"
    if [ "$(cbConfirm "Are you sure you want to delete environment $CHROOT_NAME")" -eq 0 ]; then
        cbAcknowledge "Aborting environment deletion."
        return 1
    fi
    #   sudo delete-chroot $CHROOT_NAME
    cbAcknowledge "Environment deleted."

    return 1
}

cbPurge() {
    # @needs:
    #   $LINUX_RELEASE      => xenial
    #   $HOME_DIR           => /home/chronos/user -or- /home/`ls /home/ | awk '{print $1}'`
    #   $CROUTON_ROOT       => $HOME_DIR/Downloads
    #   $CROUTON_BOOTSTRAP  => $CROUTON_ROOT/$LINUX_RELEASE.tar.bz2
    #
    # @steps:
    cbInitAction "Purge cached bootstrap"
    #   Ensure file $CROUTON_BOOTSTRAP
    #       or notify abort action + get acknowledgement
    if [ "$(cbConfirm "Are you sure you want to purge the cached $LINUX_RELEASE bootstrap")" -eq 0 ]; then
        cbAcknowledge "Aborting bootstrap purge."
        return 1
    fi
    #   rm "$CROUTON_BOOTSTRAP"
    #   Ensure not file $CROUTON_BOOTSTRAP
    #       or notify abort action + get acknowledgement
    cbAcknowledge "Bootstrap cache purged."

    return 1
}


#
# Menu Setup
#
menuItems=(
    "Create a new environment              "
    "Update an existing environment        "
    "Enter and configure/manage environment"
    "Backup environmewnt                   "
    "Restore environment                   "
    "Delete environment                    "
    "Purge cached bootstrap                "
    "Quit                                  "
)

menuActions=(
    cbCreate
    cbUpdate
    cbEnter
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
