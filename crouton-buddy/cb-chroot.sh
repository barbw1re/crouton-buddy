#!/bin/bash

cbDir=`pwd`
cd $(dirname "$0")
cbRoot=`pwd`
cd "$cbDir"

# Load bash-menu
. "$cbRoot/menu/bash-menu.sh"


#
# Menu item handlers
#
cbCoreSetup() {
    # @needs:
    #
    # @steps:
    #   Show action title

    # @placeholder:
    echo "Running Core Setup"
    read ans

    return 1
}

cbPackages() {
    # @needs:
    #
    # @steps:
    #   Show action title

    # @placeholder:
    echo "Package Installation Manager"
    read ans

    return 1
}


#
# Menu Setup
#
menuItems=(
    "Install common dependencies and core system applications"
    "Package selector and installer                          "
    "Quit                                                    "
)

menuActions=(
    cbCoreSetup
    cbPackages
    "return 0"
)


#
# Menu Configuration
#
menuTitle=" Crouton Environment Manager"
menuWidth=80
menuHighlight=$DRAW_COL_BLUE


#
# Execute Script
#
cbRun() {
    menuInit
    menuLoop
}
