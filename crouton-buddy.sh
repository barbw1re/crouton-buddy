#!/bin/bash

# Ensure we are running under bash (as this will not work under sh or dash etc)
if [ "$BASH_SOURCE" = "" ]; then
    if [ ! -x /bin/bash ]; then
        echo "ERROR: $0 needs to be run by bash and /bin/bash does not appear to be available."
        exit 1
    fi
    /bin/bash "$0"
    exit 0
fi

#
# Helper to clearly display an error message and exit
#
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

# Determine whether we are running inside or outside of a chroot
if [[ `ls -id / | cut -d ' ' -f1` -eq 2 ]]; then
    IN_CHROOT=0
    HOME_DIR="/home/chronos/user"
else
    IN_CHROOT=1
    HOME_DIR="/home/"`ls /home/ | awk '{print $1}'`
fi

# Set applicable path to Downloads directory
ROOT_DIR="$HOME_DIR/Downloads"

# Ensure we are running from Downloads directory
if [[ "$bin" != "$ROOT_DIR" ]]; then
    errorExit "Running script from invalid directory." \
              "Please ensure this is running from Downloads directory, otherwise things a likely to get screwy." \
              "You seem to be running this from $bin not $ROOT_DIR"
fi

# Crouton Buddy Urls and Paths
CB_ZIP="$ROOT_DIR/crouton-buddy.tar.gz"
CB_URL="https://raw.githubusercontent.com/barbw1re/crouton-buddy/assets/crouton-buddy.tar.gz"

CB_ROOT="$ROOT_DIR/crouton-buddy"
(( $IN_CHROOT )) && CB_APP="$CB_ROOT/cb-guest.sh" || CB_APP="$CB_ROOT/cb-host.sh"

# Download latest Crouton Buddy scripts
cbInstall() {
    # Download scripts bundle
    curl $CB_URL -L -o $CB_ZIP
    (( $? )) && errorExit "Unable to download application package."

    # Extract scripts
    tar -zxf $CB_ZIP -C $ROOT_DIR
    (( $? )) && errorExit "Unable to extract application from package."

    # Clean up
    [[ -f "$CB_ZIP" ]] && rm "$CB_ZIP"
}

# If we don't have the actual application scripts, download them
if [[ ! -d "$CB_ROOT" || ! -s "$CB_APP" ]]; then
    cbInstall
fi

# Verify application scripts were installed
[[ -d "$CB_ROOT" && -s "$CB_APP" ]] || errorExit "Unable to download application dependencies."

# Finally run the main menu script for our identified environment
. $CB_APP
cbRun

exit 0
