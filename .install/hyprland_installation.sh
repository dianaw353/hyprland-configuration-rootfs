# hyprland_installation.sh

# Function to confirm installation
_confirmInstallation() {
    echo -e "${GREEN}"
    figlet "Installation"
    echo -e "${NONE}"
    echo "This script will install the core packages of Hyperland:"
    echo "hyprland waybar rofi wofi kitty alacritty dunst dolphin xdg-desktop-portal-hyprland qt5-wayland qt6-wayland hyprpaper chromium ttf-font-awesome"
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

# hyprland_installation.sh
_installhyprlandpackages() {
    while IFS= read -r pkg
    do
        if pacman -Qs $pkg > /dev/null ; then
            echo "The package $pkg is already installed"
        else
            echo "Installing $pkg"
            paru -S --noconfirm $pkg
        fi
    done < packages.txt
}
