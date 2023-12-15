#!/bin/bash

# Source library functions
source .install/library.sh
source .install/dependencies.sh
source .install/hyprland_installation.sh
source .install/kvm.sh
source .install/keyboard.sh
source .install/monitor.sh
source .install/autostartHyprland.sh
source .install/execute_premissions.sh
source .install/git_packages.sh
source .install/setup_dotfiles.sh


# Confirm Start
_confirmInstallation

# Install packages
_installHyprlandPackages

# git packages installation
_installGitPackages

# Copy dotfiles/scripts
_copyConfigFiles

# Setup dotfiles
_setupDotfiles
_zshShell
_execute_premissions
_removegtkWindowButtons

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

