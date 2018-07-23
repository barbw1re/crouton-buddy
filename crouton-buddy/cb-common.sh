#!/bin/bash

#
# Common Helpers
#

# Abort with message
cbAbort() {
    cbError "$@"
    exit 1
}

# Ensure setup and display action banner
cbInitAction() {
    # Ensure needed globals:
    [[ "$CROUTON_APP"       != "" ]] || cbAbort "CROUTON_APP not configured"

    cbStatus "$@"

    cbEnsureCrouton "$CROUTON_APP"
    if [ "$?" -eq 1 ]; then
        cbError "ERROR: Unable to access (or download) crouton installer"
        cbAcknowledge
        return 1
    fi

    return 0
}
