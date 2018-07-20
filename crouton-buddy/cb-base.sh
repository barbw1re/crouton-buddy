#!/bin/bash

dir=`pwd`
cd $(dirname "$0")
root=`pwd`
cd "$dir"

# Load bash-menu
. "$root/menu/bash-menu.sh"


#
# Menu item handlers
#
cbCreate() {
    return 1
}
cbEnter() {
    return 1
}
cbBackup() {
    return 1
}
cbRestore() {
    return 1
}
cbDelete() {
    return 1
}
cbPurge() {
    return 1
}

#
# Menu Setup
#
menuItems=(
    "Create or update environment          "
    "Enter and configure/manage environment"
    "Backup environmewnt                   "
    "Restore environment                   "
    "Delete environment                    "
    "Purge cached bootstrap                "
    "Quit                                  "
)

menuActions=(
    cbCreate
    cbEnter
    cbBackup
    cbRestore
    cbDelete
    cbPurge
    "return 0"
)

#
# Menu Configuration
#
menuTitle=" Crouton Administration"
menuWidth=60

#
# Execute Script
#

cbRun() {
    menuInit
    menuLoop
}

