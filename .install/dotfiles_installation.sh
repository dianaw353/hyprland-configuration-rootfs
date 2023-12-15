_copyConfigFiles() {
    echo -e "${GREEN}"
    figlet "Dotfiles"
    echo -e "${NONE}"
    if gum confirm "DO YOU WANT TO COPY THE PREPARED dotfiles INTO .config? (YOU CAN ALSO DO THIS MANUALLY)" ;then
        rsync -a -I ~/hyprland-configuration-rootfs/.config ~/
        rsync -a -I ~/hyprland-configuration-rootfs/.hushlogin ~/
        rsync -a -I ~/hyprland-configuration-rootfs/.zprofile ~/
        rsync -a -I ~/hyprland-configuration-rootfs/.zsh_aliases ~/
        rsync -a -I ~/hyprland-configuration-rootfs/.zshrc ~/
        rsync -a -I ~/hyprland-configuration-rootfs/.wallpaper ~/
        rsync -a -I ~/hyprland-configuration-rootfs/.local ~/
        rsync -a -I ~/hyprland-configuration-rootfs/.current_wallpaper ~/
        echo ""
        echo ":: Configuration files successfully copied to ~/.config/"
        echo ""
    elif [ $? -eq 130 ]; then
        exit 130
    else
        echo ""
        echo "Installation canceled."
        echo "PLEASE NOTE: Open ~/.config/hypr/hyprland.conf to change your keyboard layout (default is us) and your screen resolution (default is preferred) if needed."
        echo "Then reboot your system!"
        exit;
    fi
}
