#!/bin/bash
# _   _                  _                 _   ____  _             _
# | | | |_   _ _ __  _ __| | __ _ _ __   __| | / ___|| |_ __ _ _ __| |_ ___ _ __
# | |_| | | | | '_ \| '__| |/ _` | '_ \ / _` | \___ \| __/ _` | '__| __/ _ \ '__|
# |  _  | |_| | |_) | |  | | (_| | | | | (_| |  ___) | || (_| | |  | ||  __/ |
# |_| |_|\__, | .__/|_|  |_|\__,_|_| |_|\__,_| |____/ \__\__,_|_|   \__\___|_|
#        |___/|_|
#
# The Hyprland Starter Script
# Based of of Stephan Raabe Hyprland settings  
# by Diana Ward (2023) 
# --------------------------------------------------------------------------------

clear
installFolder=$(dirname "$(pwd)")

# Source files
source .library/version.sh
source .library/library.sh

# Define global variables
modules_path="modules"
current=""
back=""
clickArr=""
confDir="conf"

# Start Application
_getModules $(pwd)/$modules_path

