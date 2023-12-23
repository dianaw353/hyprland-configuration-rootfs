# Function to confirm installation
_confirmInstallation() {
    echo -e "${GREEN}"
    figlet "Installation"
    echo -e "${NONE}"
    echo "This script will install the core packages of Hyperland:"
    echo ""
    echo "IMPORTANT: Backup existing configurations in .config if needed."
    echo "This script doesn't support NVIDIA graphics driver."
    if gum confirm "DO YOU WANT TO START THE INSTALLATION NOW?" ;then
        echo ""
        echo ":: Installing Hyprland and additional packages"
        echo ""
    elif [ $? -eq 130 ]; then
        exit 130
    else
        echo ""
        echo "Installation canceled."
        exit;
    fi
}
_confirmInstallation
