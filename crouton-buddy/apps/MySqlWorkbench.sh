#!/bin/bash

# Application display name
MySqlWorkbench_App="MySQL Workbench database manager"

# Application install function
MySqlWorkbench_Install() {
    sudo apt install -y mysql-workbench
}

# Application verification function
# Return 0 if installed, 1 if not installed
MySqlWorkbench_Verify() {
    # Verification steps
    return 1
}
