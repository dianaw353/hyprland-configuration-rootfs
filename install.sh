#!/bin/bash

# Source library functions
source .install/library.sh
source .install/dependencies.sh
source .install/hyprland_installation.sh
source .install/kvm.sh
source .install/keyboard.sh
source .install/monitor.sh
source .install/autostartHyprland.sh

# Confirm Start
_confirmInstallation

# Install packages
_installHyprlandPackages

# Copy configuration
_copyConfigFiles

# Run the KVM environment setup
_setupKVMEnvironment

# Run the keyboard setup
_setupkeyboardlayout

# Run the monitor setup
_setupMonitor

# Set up KVM environment variables
_setupKVMEnvironment

# Set up hyprland autostart
_autostartHyprland

# Display completion message
_displayCompletionMessage

