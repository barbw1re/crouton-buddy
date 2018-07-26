#!/bin/bash

################################################################
# Crouton functionality Helpers 
################################################################

# Globals
CROUTON_URL="https://goo.gl/fd3zc"

#
# Download Crouton installer if it is missing
#
# Return 0 on success, 1 on failure
#
cbEnsureCrouton() {
    # Ensure parameter(s)
    [[ -z "$1" ]] && return 1

    local croutonApp="$1"

    if [[ ! -s "$croutonApp" ]]; then
        cbInfo "Fetching crouton installer ..."
        echo ""
        curl $CROUTON_URL -L -o $croutonApp
        echo ""
    fi

    # Verify
    [[ -s "$croutonApp" ]] && return 0 || return 1
}

#
# Download a Crouton bootstrap using our current targets if it is missing
#
# Return 0 on success, 1 on failure
#
cbEnsureBootstrap() {
    # Ensure needed globals:
    [[ "$CROUTON_APP"       ]] || cbAbort "CROUTON_APP not configured"
    [[ "$CROUTON_BOOTSTRAP" ]] || cbAbort "CROUTON_BOOTSTRAP not configured"
    [[ "$CROUTON_TARGETS"   ]] || cbAbort "CROUTON_TARGETS not configured"
    [[ "$LINUX_RELEASE"     ]] || cbAbort "LINUX_RELEASE not configured"

    if [[ ! -s "$CROUTON_BOOTSTRAP" ]]; then
        cbInfo "Downloading bootstrap for $LINUX_RELEASE ..."
        sudo sh $CROUTON_APP -d -f $CROUTON_BOOTSTRAP -r $LINUX_RELEASE -t $CROUTON_TARGETS
        echo ""

        # Verify
        if [[ ! -s "$CROUTON_BOOTSTRAP" ]]; then
            cbError "ERROR: Unable to download the $LINUX_RELEASE bootstrap"
            return 1
        fi
    fi

    return 0
}

#
# Check if provided name is a valid (existing) chroot name
#
# Return 1 if name is chroot, 0 if not
#
cbIsChroot() {
    # Ensure parameter(s)
    [[ -z "$1" ]] && return 0

    # Ensure needed globals:
    [[ "$CHROOT_ROOT" ]] || cbAbort "CHROOT_ROOT not configured"

    if [[ -d "$CHROOT_ROOT/$1" ]]; then
        echo 1
        return 1
    fi

    echo 0
    return 0
}

#
# Return number of currently installed chroot environments
#
cbCountChroots() {
    # Ensure needed globals:
    [[ "$CHROOT_ROOT" ]] || cbAbort "CHROOT_ROOT not configured"

    local chroot=""
    local chrootCount=0

    for chroot in $CHROOT_ROOT/* ; do
        [[ -d "$chroot" ]] && chrootCount=$((chrootCount+1))
    done

    echo $chrootCount
    return $chrootCount
}

#
# Display a list of currently installed chroot environments
#
# Optionally provide a header message to show in place of the default:
#   "Available environments:"
#
# If no chroots are installed, the following message will be displayed:
#   "No available environments"
#
# Each environment will be displayed according to the format:
#   [ * Name]
#
# Note the leading space and asterisk.
cbListChroots() {
    # Ensure needed globals:
    [[ "$CHROOT_ROOT" ]] || cbAbort "CHROOT_ROOT not configured"

    [[ -z "$1" ]] && msg="Available environments:" || msg="$1"

    if (( ! $(cbCountChroots) )); then
        echo " No available environments"
    else
        echo " $msg"
        for chroot in $CHROOT_ROOT/* ; do
            [[ -d "$chroot" ]] && echo " * $(basename "$chroot")"
        done
    fi

    echo ""
}

#
# Check if a file is a valid Crouton backup file
#
# Return 1 if file is backup, 0 if not
#
cbIsBackupFile() {
    local ret=0
    local file="$1"

    # Confirm it's a backup tarball
    local label=`tar --test-label -f "$file" 2> /dev/null`
    if [[ "$label" && "`echo "$label" | grep crouton | grep backup`" ]]; then
        ret=1
    fi

    echo $ret
    return $ret
}

#
# Return number of identified backup files
#
cbCountBackups() {
    # Ensure needed globals:
    [[ "$ROOT_DIR"    ]] || cbAbort "ROOT_DIR not configured"
    [[ -d "$ROOT_DIR" ]] || cbAbort "Unable to access ROOT_DIR ($ROOT_DIR)"

    local file=""
    local backupCount=0

    for file in $ROOT_DIR/* ; do
        (( "$(cbIsBackupFile "$file")" )) && backupCount=$((backupCount+1))
    done

    echo $backupCount
    return $backupCount
}

#
# Display a list of identified Crouton backup files.
#
# If no backup files are found, the following message will be displayed:
#   "No available backups to restore"
#
# The list of backup files will be preceded with the message:
#   "Available backup files to restore:"
#
# Each backup file will be displayed according to the format:
#   [ * Filename]
#
# Note the leading space and asterisk.
#
cbListBackups() {
    # Ensure needed globals:
    [[ "$ROOT_DIR"    ]] || cbAbort "ROOT_DIR not configured"
    [[ -d "$ROOT_DIR" ]] || cbAbort "Unable to access ROOT_DIR ($ROOT_DIR)"

    if (( ! $(cbCountBackups) )); then
        echo " No available backups to restore"
    else
        echo " Available backup files to restore:"
        for file in $ROOT_DIR/* ; do
            (( "$(cbIsBackupFile "$file")" )) && echo " * $(basename "$file")"
        done
    fi

    echo ""
}
