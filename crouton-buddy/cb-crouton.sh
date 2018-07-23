#!/bin/bash

# Globals
CROUTON_URL="https://goo.gl/fd3zc"

# cbEnsureCrouton(croutonApp)
cbEnsureCrouton() {
    # Ensure parameter(s)
    [[ ! -z "$1" ]] || return 1

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

cbEnsureBootstrap() {
    # Ensure needed globals:
    [[ "$CROUTON_APP"       != "" ]] || cbAbort "CROUTON_APP not configured"
    [[ "$CROUTON_BOOTSTRAP" != "" ]] || cbAbort "CROUTON_BOOTSTRAP not configured"
    [[ "$CROUTON_TARGETS"   != "" ]] || cbAbort "CROUTON_TARGETS not configured"
    [[ "$LINUX_RELEASE"     != "" ]] || cbAbort "LINUX_RELEASE not configured"

    if [[ ! -s "$CROUTON_BOOTSTRAP" ]]; then
        cbInfo "Downloading bootstrap for $LINUX_RELEASE ..."
        sudo sh $CROUTON_APP -d -f $CROUTON_BOOTSTRAP -r $LINUX_RELEASE -t $CROUTON_TARGETS

        # Verify
        if [[ ! -s "$CROUTON_BOOTSTRAP" ]]; then
            cbError "ERROR: Unable to download the $LINUX_RELEASE bootstrap"
            return 1
        fi
    fi

    return 0
}

cbIsChroot() {
    # Ensure parameter(s)
    [[ ! -z "$1" ]] || return 0

    # Ensure needed globals:
    [[ "$CHROOT_ROOT" != "" ]] || cbAbort "CHROOT_ROOT not configured"

    if [[ -d "$CHROOT_ROOT/$1" ]]; then
        echo 1
        return 1
    fi

    echo 0
    return 0
}

cbCountChroots() {
    # Ensure needed globals:
    [[ "$CHROOT_ROOT" != "" ]] || cbAbort "CHROOT_ROOT not configured"

    local chroot=""
    local chrootCount=0

    for chroot in $CHROOT_ROOT/* ; do
        if [[ -d "$chroot" ]]; then
            chrootCount=$((chrootCount+1))
        fi
    done

    echo $chrootCount
    return $chrootCount
}

cbListChroots() {
    # Ensure needed globals:
    [[ "$CHROOT_ROOT" != "" ]] || cbAbort "CHROOT_ROOT not configured"

    [[ -z "$1" ]] && msg="Available environments:" || msg="$1"

    if [[ $(cbCountChroots) -eq 0 ]]; then
        echo " No available environments"
    else
        echo " $msg"
        for chroot in $CHROOT_ROOT/* ; do
            [[ -d "$chroot" ]] && echo " * $(basename "$chroot")"
        done
    fi

    echo ""
}

cbIsBackupFile() {
    local ret=0
    local file="$1"

    # Confirm it's a tarball
    if tar --test-label -f "$file" >/dev/null 2>&1; then
        ret=1
    fi

    echo $ret
    return $ret
}

cbCountBackups() {
    # Ensure needed globals:
    [[ "$ROOT_DIR" != "" ]] || cbAbort "ROOT_DIR not configured"
    [[ -d "$ROOT_DIR"    ]] || cbAbort "Unable to access ROOT_DIR ($ROOT_DIR)"

    local file=""
    local backupCount=0

    for file in $ROOT_ROOT/* ; do
        [[ "$(cbIsBackupFile "$file")" -eq 1 ]] && backupCount=$((backupCount+1))
    done

    echo $backupCount
    return $backupCount
}

cbListBackups() {
    # Ensure needed globals:
    [[ "$ROOT_DIR" != "" ]] || cbAbort "ROOT_DIR not configured"
    [[ -d "$ROOT_DIR"    ]] || cbAbort "Unable to access ROOT_DIR ($ROOT_DIR)"

    if [[ $(cbCountBackups) -eq 0 ]]; then
        echo " No available backups to restore"
    else
        echo " Available backup files to restore:"
        for file in $ROOT_ROOT/* ; do
            if [[ "$(cbIsBackupFile "$file")" -eq 1 ]]; then
                echo " * $(basename "$file")"
            fi
        done
    fi

    echo ""
}
