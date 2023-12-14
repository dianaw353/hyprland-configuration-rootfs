if [ ! $mode == "dev" ]; then
    directories=(alacritty .local .wallpaper)
    files=(.current_wallpaper .hushlogin .zprofile .zsh_aliases .zshrc)

    for dir in "${directories[@]}"; do
        if [ -d "~/hyprland-configuration-rootfs/.config-versions/$version/$dir" ]; then
            mkdir -p ~/.config/$dir
            rm -rf ~/.config/$dir
            _installSymLink $dir ~/.config/$dir ~/hyprland-configuration-rootfs/.config/$dir ~/.config
        fi
    done

    for file in "${files[@]}"; do
        if [ -f "~/hyprland-configuration-rootfs/.config-versions/$version/$file" ]; then
            rm -f ~/$file
            _installSymLink $file ~/$file ~/hyprland-configuration-rootfs/.config/$file ~/
        fi
    done
else
    echo "Skipped: DEV MODE!"
fi
echo "Symbolic links created."
echo ""

