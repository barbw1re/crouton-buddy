#!/bin/bash

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
