#!/bin/bash

# Set by caller:
#
# me       => full path to caller (crouton-buddy.sh script)
# CB_ROOT  => full path to Crouton Buddy application directory
# HOME_DIR => full path to home directory
# ROOT_DIR => full path to Downloads directory

# Load dependencies
. "$CB_ROOT/cb-ui.sh"
. "$CB_ROOT/cb-crouton.sh"
. "$CB_ROOT/menu/bash-menu.sh"


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
