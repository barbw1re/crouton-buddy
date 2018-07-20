#!/bin/bash

# Globals
CROUTON_URL="https://goo.gl/fd3zc"

# cbEnsureCrouton(croutonApp)
cbEnsureCrouton() {
    # Ensure parameter(s)
    [[ ! -z "$1" ]] || return 0

    local croutonApp="$1"

    if [[ ! -s "$croutonApp" ]]; then
        cbInfo "Fetching crouton installer ..."
        curl $CROUTON_URL -L -o $croutonApp
    fi

    # Verify
    [[ -s "$croutonApp" ]] && return 1 || return 0
}

cbEnsureBootstrap() {
    # Ensure parameter(s)

    if [[ ! -s "$CROUTON_BOOTSTRAP" ]]; then
        cbInfo "Downloading bootstrap for $LINUX_RELEASE ..."
        sudo sh $CROUTON_APP -d -f $CROUTON_BOOTSTRAP -r $LINUX_RELEASE -t $CROUTON_TARGETS

        # Verify
        if [[ ! -s "$CROUTON_BOOTSTRAP" ]]; then
            cbError "ERROR: Unable to download the $LINUX_RELEASE bootstrap"
            return 0
        fi
    fi

    return 1
}
