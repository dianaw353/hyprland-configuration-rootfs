#!/bin/bash

# Function to check if user is using a VM and update config file accordingly
updateConfigFile() {
    # Ask the user if they are using a VM using Gum
    if gum confirm "Are you using a VM?"; then
        # Add a line to the config file
        echo "env = WLR_NO_HARDWARE_CURSORS, 1" >> "$HOME/.config/hypr/conf/env/default.conf"
        echo "Configuration updated for VM usage."
    else
        echo "No changes made to the configuration."
    fi
}

# Call the function to update the config file
updateConfigFile

