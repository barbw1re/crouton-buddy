#!/bin/bash

errorExit() {
    echo -e "\n****************\n"
    echo "ERROR: $1"
    if [ ! -z "$2" ]; then
        shift
        echo ""
        for msg in "$@" ; do
            echo "$msg"
        done
    fi
    echo -e "\n****************\n"

    exit 1    
}

# Ensure we are running under bash (will not work under sh or dash etc)
if [ "$BASH_SOURCE" = "" ]; then
    [ -x /bin/bash ] || errorExit "$0 needs to be run by bash and /bin/bash does not appear to be available."
    /bin/bash "$0"
    exit 0 
fi

# Ensure we are running as root
if [[ `id -u` -gt 0 ]]; then
    errorExit "Unable to run as regular user. Please run as root:" \
              "  $ sudo sh $0"
fi

# Get script file and run directory
me=$(basename "$0")
dir=`pwd`
cd $(dirname "$0")
bin=`pwd`
cd "$dir"

# Determine whether we are running inside or outside of a chroot
if [[ "`ls -id / | awk '{print $1}'`" -eq 2 ]]; then
    IN_CHROOT=0
    HOME_DIR="/home/chronos/user"
else
    IN_CHROOT=1
    HOME_DIR="/home/"`ls /home/ | awk '{print $1}'`
fi

# Set applicable path to Downloads directory
ROOT_DIR="$HOME_DIR/Downloads"

# Crouton Buddy Paths
CB_URL="https://"
CB_ROOT="$ROOT_DIR/crouton-buddy"
[[ $IN_CHROOT -eq 1 ]] && CB_APP="$CB_ROOT/cb-guest.sh" || CB_APP="$CB_ROOT/cb-host.sh"
CB_ZIP="$CB_ROOT/crouton-buddy.tar.gz"

# Ensure we are running from Downloads directory
if [[ "$bin" != "$ROOT_DIR" ]]; then
    errorExit "Running script from invalid directory." \
              "Please ensure this is running from Downloads directory, otherwise things a likely to get screwy." \
              "You seem to be running this from $bin not $ROOT_DIR"
fi

# If we don't have the actual application scripts, download them
if [[ ! -d "$CB_ROOT" || ! -s "$CB_APP" ]]; then
    # Make applicatrion directory
    mkdir "$CB_ROOT" 2> /dev/null
    [[ $? -eq 0 ]] || errorExit "Unable to create application directory ($CB_ROOT)."

    # Download scripts bundle
    curl $CB_URL -L -o $CB_ZIP
    [[ $? -eq 0 ]] || errorExit "Unable to download application package."

    # Extract scripts
    tar -zxf $CB_ZIP -C $CB_ROOT
    [[ $? -eq 0 ]] || errorExit "Unable to extract application from package."
fi

# Verify application scripts were installed
[[ -d "$CB_ROOT" && -s "$CB_APP" ]] || errorExit "Unable to download application dependencies."

# Finally run the applicable main application script
. $CB_APP
cbRun

exit 0
