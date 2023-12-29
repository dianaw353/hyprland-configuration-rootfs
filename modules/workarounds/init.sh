#!/bin/bash

# Function to explain and load a kernel module
loadKernelModule() {
    module_name="hid_sensor_hub"

    # Check if the module is already loaded
    if lsmod | grep -wq "$module_name"; then
        echo "The '$module_name' module is already loaded."
        return
    fi

    # Explain why the module is needed
    echo "The '$module_name' module is related to the autobrightness sensor on your Framework Laptop."
    echo "Disabling this sensor may allow the keybinds for brightness control to work as a workaround."

    # Prompt user for confirmation to load the module using Gum
    if gum confirm "Do you want to load the '$module_name' module to disable the autobrightness sensor?"; then
        # Run the command with sudo
        sudo modprobe -i "$module_name"
        echo "Module '$module_name' loaded successfully. The autobrightness sensor is now disabled."
    else
        echo "Module loading aborted. The autobrightness sensor remains enabled."
        exit 1
    fi
}

# Call the function to load the kernel module
loadKernelModule
