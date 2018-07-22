#!/bin/bash

lineBreak() {
    echo ""
    echo "**********"
    echo ""
}

errorExit() {
    lineBreak
    echo "ERROR: $1"
    if [ ! -z "$2" ]; then
        shift
        echo ""
        for msg in "$@" ; do
            echo "$msg"
        done
    fi
    lineBreak

    exit 1
}

# Ensure we are running under bash (will not work under sh or dash etc)
if [ "$BASH_SOURCE" = "" ]; then
    [ -x /bin/bash ] || errorExit "$0 needs to be run by bash and /bin/bash does not appear to be available"
    /bin/bash "$0"
    exit 0
fi

# Ensure we are running as root
if [[ `id -u` -gt 0 ]]; then
    errorExit "ERROR: Unable to run as regular user. Please run as root:" \
              "  $ sudo sh $0"
fi

# Get script file and run directory
me=$(dirname "$0")
dir=`pwd`
cd $(dirname "$0")
bin=`pwd`
cd "$dir"

#me=$(basename "$0")
#me="crouton-buddy/$me"

#execDir=`pwd`
#cd $(dirname "$0")
#bin=`pwd`
#cd "$execDir"

HOME_DIR="/home/chronos/user"
ROOT_DIR="$HOME_DIR/Downloads"

CB_ROOT="$ROOT_DIR/crouton-buddy"
CB_APP="$CB_ROOT/cb-base.sh"

. $CB_APP
cbRun

exit 0
