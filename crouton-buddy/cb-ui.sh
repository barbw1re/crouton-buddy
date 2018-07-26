#!/bin/bash

################################################################
# Fancy UI Helpers
################################################################

#
# Colour Codes
#
CB_COL_BOLD="1"
CB_COL_RESET="0"

CB_COL_BLACK="30"
CB_COL_WHITE="97"

CB_COL_BG_RED="41"
CB_COL_BG_GREEN="42"
CB_COL_BG_YELLOW="43"
CB_COL_BG_BLUE="44"

#
# Output message to screen
#
cbMessage() {
    local screenWidth=$(tput cols)

    printf '%*s\n' "${COLUMNS:-$screenWidth}" '' | tr ' ' ' '
    while [[ ! -z "$1" ]]; do
        printf '%-*s\n' "${COLUMNS:-$screenWidth}" "  $1" | tr ' ' ' '
        shift
    done
    printf '%*s' "${COLUMNS:-$screenWidth}" '' | tr ' ' ' '
    printf "\033[${COL_RESET}m\n\n"
}

#
# Output message with green background to screen
#
cbStatus() {
    printf "\033[${CB_COL_BOLD};${CB_COL_WHITE};${CB_COL_BG_GREEN}m"
    cbMessage "$@"
}

#
# Output message with blue background to screen
#
cbInfo() {
    printf "\033[${CB_COL_BOLD};${CB_COL_WHITE};${CB_COL_BG_BLUE}m"
    cbMessage "$@"
}

#
# Output message with yellow background to screen
#
cbWarning() {
    printf "\033[${CB_COL_BOLD};${CB_COL_WHITE};${CB_COL_BG_YELLOW}m"
    cbMessage "$@"
}

#
# Output message with red background to screen
#
cbError() {
    printf "\033[${CB_COL_BOLD};${CB_COL_WHITE};${CB_COL_BG_RED}m"
    cbMessage "$@"
}

#
# Get acknowledgement from user
# Optionally display a status (green background) message
#
cbAcknowledge() {
    if [[ ! -z "$1" ]]; then
        echo ""
        cbStatus "$@"
    fi
    read -p " Press enter to continue ... "
}

#
# Get acknowledgement of abort from user
# Optionally display a warning (yellow background) message
#
cbAcknowledgeAbort() {
    if [[ ! -z "$1" ]]; then
        echo ""
        cbWarning "$@"
    fi
    read -p " Press enter to continue ... "
}

#
# Get a text response from user
#
cbAsk() {
    read -p " $*" resp
    echo "$resp"
}

#
# Get confirmation from user
#
cbConfirm() {
    while true ; do
        read -p " $* (y/n): " yn
        case ${yn} in
            [Yy]*)  echo 1; return 1
                    ;;
            [Nn]*)  echo 0; return 0
                    ;;
        esac
    done
}
