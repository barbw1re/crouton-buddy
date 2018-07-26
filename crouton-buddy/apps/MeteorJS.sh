#!/bin/bash

# Application display name
MeteorJS_App="MeteorJS library"

# Application install function
MeteorJS_Install() {
    sudo curl "https://install.meteor.com/" | sh
}

# Application verification function
# Return 0 if installed, 1 if not installed
MeteorJS_Verify() {
    # @todo: Determine correct verification
    return 0
}
