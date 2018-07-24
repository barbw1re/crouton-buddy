#!/bin/bash

# Application display name
VsCode_App="Microsoft Visual Studio Code IDE"

# Application install function
VsCode_Install() {
    local needUpdate=0

    if [[ ! -s "/etc/apt/trusted.gpg.d/microsoft.gpg" ]]; then
        curl https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > microsoft.gpg
        sudo mv microsoft.gpg /etc/apt/trusted.gpg.d/microsoft.gpg
        needUpdate=1
    fi

    if [[ ! -s "/etc/apt/sources.list.d/vscode.list" ]]; then
        sudo sh -c 'echo "deb [arch=amd64] https://packages.microsoft.com/repos/vscode stable main" > /etc/apt/sources.list.d/vscode.list'
        needUpdate=1
    fi

    (( $needUpdate )) && sudo apt update -y

    # Install VS Code
    sudo apt install -y code
}

# Application verification function
# Return 0 if installed, 1 if not installed
VsCode_Verify() {
    [[ "`which code 2> /dev/null`" ]] && return 0 || return 1
}
