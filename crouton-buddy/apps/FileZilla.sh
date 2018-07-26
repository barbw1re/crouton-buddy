#!/bin/bash

# Application display name
FileZilla_App="FileZilla FTP client"

# Application install function
FileZilla_Install() {
    sudo apt install -y filezilla
}

# Application verification function
# Return 0 if installed, 1 if not installed
FileZilla_Verify() {
    [[ "`which filezilla 2> /dev/null`" ]] && return 0 || return 1
}
