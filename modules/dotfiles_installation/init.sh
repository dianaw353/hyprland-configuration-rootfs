figlet "Dotfiles Installation"
echo "Installing Dotfiles"

if gum confirm "DO YOU WANT TO COPY THE PREPARED dotfiles INTO .config? (YOU CAN ALSO DO THIS MANUALLY)" ; then
    rm -rf ~/.config
    rsync -a -I ~/hyprland-configuration-rootfs/.config/* ~/.config
    rsync -a -I ~/hyprland-configuration-rootfs/.current_wallpaper ~
    rsync -a -I ~/hyprland-configuration-rootfs/.hushlogin ~/
    rsync -a -I ~/hyprland-configuration-rootfs/.wallpaper/* ~/
    rsync -a -I ~/hyprland-configuration-rootfs/.zsh_aliases ~/
    rsync -a -I ~/hyprland-configuration-rootfs/.zshrc ~/
    mkdir ~/Pictures/
    mkdir ~/Pictures/screenshots/
    echo ""
    echo ":: Configuration files successfully copied dotfiles"
    echo ""
    echo "Enabling Hyprland and Waybar scripts"
    chmod +x ~/.config/hypr/scripts/*
    chmod +x ~/.config/waybar/scripts/*
    echo "Switching shell to Zsh..."
    chsh -s /bin/zsh
elif [ $? -eq 130 ]; then
    exit 130
else
    echo ""
    echo "Installation canceled."
    echo "PLEASE NOTE: Open ~/.config/hypr/hyprland.conf to change your keyboard layout (default is us) and your screen resolution (default is preferred) if needed."
    echo "Then reboot your system!"
    exit;
fi

