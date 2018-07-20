#!/bin/bash

cbDir=`pwd`
cd $(dirname "$0")
cbDir=`pwd`
cd "$cbDir"

# Load bash-menu
. "$cbDir/menu/bash-menu.sh"


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
    #   Show action title
    #   Do:
    #       **MAYBE** List environments
    #       Enter environment (into $CHROOT_NAME)
    #           or notify abort action + get acknowledgement
    #   While exists environmewnt $CHROOT_NAME
    #   Confirm create $CHROOT_NAME
    #       or notify abort action + get acknowledgement
    #   Ensure bootstrap
    #       Ensure file $CROUTON_BOOTSTRAP
    #           or:
    #               Notify bootstrap download for $LINUX_RELEASE
    #               sudo sh $CROUTON_APP -d -f $CROUTON_BOOTSTRAP -r $LINUX_RELEASE -t $CROUTON_TARGETS
    #       Ensure file $CROUTON_BOOTSTRAP (to verify)
    #           or notify abort action + get acknowledgement
    #   Notify creating installation of $LINUX_RELEASE as $CHROOT_NAME
    #   Notify using $CROUTON_TARGETS
    #   Confirm perform install
    #       or notify abort action + get acknowledgement
    #   sudo sh $CROUTON_APP -n $CHROOT_NAME -f $CROUTON_BOOTSTRAP -t $CROUTON_TARGETS
    #   **MAYBE**: Notify success + get acknowledgement

    # @placeholder:
    echo "Create new environment"
    read ans

    return 1
}

cbUpdate() {
    # @needs:
    #   $bin                => Directory of calling script (Downloads directory)
    #   $CROUTON_APP        => $bin/crouton
    #
    # @steps:
    #   Show action title
    #   Pick existing environment (into $CHROOT_NAME)
    #       or notify abort action + get acknowledgement
    #   Confirm update $CHROOT_NAME
    #       or notify abort action + get acknowledgement
    #   sudo sh $CROUTON_APP -n $CHROOT_NAME -u
    #   **MAYBE**: Notify success + get acknowledgement

    # @placeholder:
    echo "Update environment"
    read ans

    return 1
}

cbEnter() {
    # @needs:
    #   $me                 => Calling script in Downloads directory (crouton-buddy.sh)
    #   $CHROOT_ROOT        => /mnt/stateful_partition/crouton/chroots
    #
    # @steps:
    #   Show action title
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
    #   Show action title
    #   Require at least 1 environment
    #       or notify abort action + get acknowledgement
    #   Pick existing environment (into $CHROOT_NAME)
    #       or notify abort action + get acknowledgement
    #   Confirm backup of $CHROOT_NAME
    #       or notify abort action + get acknowledgement
    #   sudo edit-chroot -b $CHROOT_NAME
    #   **MAYBE**: Notify success + get acknowledgement

    # @placeholder:
    echo "Backing up environment"
    read ans

    return 1
}

cbRestore() {
    # @needs:
    #   $CROUTON_ROOT       => $HOME_DIR/Downloads
    #
    # @steps:
    #   Show action title
    #   Pick backup file from $CROUTON_ROOT
    #       *** Can we restore specific version? ***
    #       or notify abort action + get acknowledgement
    #   Pick or enter environment (into $CHROOT_NAME)
    #       *** Determine name from file and pre-fill picker ***
    #       or notify abort action + get acknowledgement
    #   If exists $CHROOT_NAME:
    #       Confirm overwrite environment $CHROOT_NAME
    #           or notify abort action + get acknowledgement
    #       sudo edit-chroot -rr $CHROOT_NAME
    #   Else:
    #       Confirm create environment $CHROOT_NAME
    #           or notify abort action + get acknowledgement
    #       sudo edit-chroot -r $CHROOT_NAME
    #   **MAYBE**: Notify success + get acknowledgement

    # @placeholder:
    echo "Creating new environment via restore"
    echo " - or -"
    echo "Replacing environment with restore"
    read ans

    return 1
}

cbDelete() {
    # @needs:
    #   Nothing
    #
    # @steps:
    #   Show action title
    #   Pick existing environment (into $CHROOT_NAME)
    #       or notify abort action + get acknowledgement
    #   Confirm delete of $CHROOT_NAME
    #       or notify abort action + get acknowledgement
    #   sudo delete-chroot $CHROOT_NAME
    #   **MAYBE**: Notify success + get acknowledgement

    # @placeholder:
    echo "Deleting environment"
    read ans

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
    #   Show action title
    #   Ensure file $CROUTON_BOOTSTRAP
    #       or notify abort action + get acknowledgement
    #   Confirm delete $LINUX_RELEASE bootstrap
    #       or notify abort action + get acknowledgement
    #   rm "$CROUTON_BOOTSTRAP"
    #   Ensure not file $CROUTON_BOOTSTRAP
    #       or notify abort action + get acknowledgement
    #   Notify success + get acknowledgement

    # @placeholder:
    echo "Deleting bootstrap cache"
    read ans

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
