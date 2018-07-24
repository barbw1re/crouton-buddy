#!/bin/bash

FileZilla_App="FileZilla FTP client"

FileZilla_Install() {
    sudo apt install -y filezilla
}

FileZilla_Verify() {
    [[ "`which filezilla 2> /dev/null`" = "" ]] && return 1 || return 0
}
