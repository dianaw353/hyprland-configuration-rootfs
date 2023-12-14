if [ ! $mode == "dev" ]; then
    if [ -d ~/hyprland-configuration-rootfs/home/diana/.config-versions/$version/alacritty ]; then
        _installSymLink alacritty ~/.config/alacritty ~/hyprland-configuration-rootfs/home/diana/.config/alacritty/ ~/.config
    fi
    # Add similar if statements for the rest of the directories...
    if [ -f ~/hyprland-configuration-rootfs/home/diana/.config-versions/$version/.current_wallpaper ]; then
        _installSymLink .current_wallpaper ~/.current_wallpaper ~/hyprland-configuration-rootfs/home/diana/.config/.current_wallpaper ~/
    fi
    if [ -f ~/hyprland-configuration-rootfs/home/diana/.config-versions/$version/.hushlogin ]; then
        _installSymLink .hushlogin ~/.hushlogin ~/hyprland-configuration-rootfs/home/diana/.config/.hushlogin ~/
    fi
    if [ -d ~/hyprland-configuration-rootfs/home/diana/.config-versions/$version/.local ]; then
        _installSymLink .local ~/.local ~/hyprland-configuration-rootfs/home/diana/.config/.local ~/
    fi
    if [ -d ~/hyprland-configuration-rootfs/home/diana/.config-versions/$version/.wallpaper ]; then
        _installSymLink .wallpaper ~/.wallpaper ~/hyprland-configuration-rootfs/home/diana/.config/.wallpaper ~/
    fi
    if [ -f ~/hyprland-configuration-rootfs/home/diana/.config-versions/$version/.zprofile ]; then
        _installSymLink .zprofile ~/.zprofile ~/hyprland-configuration-rootfs/home/diana/.config/.zprofile ~/
    fi
    if [ -f ~/hyprland-configuration-rootfs/home/diana/.config-versions/$version/.zsh_aliases ]; then
        _installSymLink .zsh_aliases ~/.zsh_aliases ~/hyprland-configuration-rootfs/home/diana/.config/.zsh_aliases ~/
    fi
    if [ -f ~/hyprland-configuration-rootfs/home/diana/.config-versions/$version/.zshrc ]; then
        _installSymLink .zshrc ~/.zshrc ~/hyprland-configuration-rootfs/home/diana/.config/.zshrc ~/
    fi
else
    echo "Skipped: DEV MODE!"
fi
echo "Symbolic links created."
echo ""

