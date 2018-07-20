#!/bin/bash

# Globals
CROUTON_URL="https://goo.gl/fd3zc"


cbEnsureCrouton() {
    if [[ ! -s "$CROUTON_APP" ]]; then
        cbInfo "Fetching crouton..."
        curl $CROUTON_URL -L -o $CROUTON_APP
    fi

    # Verify
    [ -s "$CROUTON_APP" ] && return 1 || return 0
}

