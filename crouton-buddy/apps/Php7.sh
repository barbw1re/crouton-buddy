#!/bin/bash

# Application display name
Php7_App="PHP v7.0"

# Application install function
Php7_Install() {
    sudo apt install -y php php-pear
}

# Application verification function
# Return 0 if installed, 1 if not installed
Php7_Verify() {
    php -v > /dev/null 2>&1 | grep "7.0"
    return $?
}
