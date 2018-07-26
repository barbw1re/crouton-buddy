#!/bin/bash

################################################################
# Common Helpers
################################################################

#
# Terminate with message
#
cbAbort() {
    cbError "$@"
    exit 1
}

#
# Ensure common setup and display action banner
#
# Return 0 on success, 1 on error
#
cbInitAction() {
    # Ensure needed globals:
    [[ "$CROUTON_APP" ]] || cbAbort "CROUTON_APP not configured"

    cbStatus "$@"

    cbEnsureCrouton "$CROUTON_APP"
    if (( $? )); then
        cbError "ERROR: Unable to access (or download) crouton installer"
        cbAcknowledge
        return 1
    fi

    return 0
}
