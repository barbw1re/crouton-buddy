#!/bin/bash

if [ "$BASH_SOURCE" = "" ]; then
    /bin/bash "$0"
    exit 0
fi

errorExit() {
    echo -e "\n****************\n"
    echo "ERROR: $1"
    if [[ ! -z "$2" ]]; then
        shift
        echo ""
        for msg in "$@" ; do
            echo "$msg"
        done
    fi
    echo -e "\n****************\n"

    exit 1    
}

# Ensure we are running as root
(( `id -u` )) && errorExit "Unable to run as regular user. Please run as root:" \
                           "  $ sudo sh $0"

# Get script file and run directory
me=$(basename "$0")
execDir=`pwd`
cd $(dirname "$0")
bin=`pwd`
cd "$execDir"

ROOT_DIR="$bin"
CB_ROOT="$ROOT_DIR/crouton-buddy"

HOME_DIR="/home/"`ls /home/ | awk '{print $1}'`

# HOST mode
#CB_APP="$CB_ROOT/cb-host.sh"

# GUEST mode
CB_APP="$CB_ROOT/cb-guest.sh"

. $CB_APP
cbRun

exit 0
