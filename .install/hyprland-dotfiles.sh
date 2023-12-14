if [ ! $mode == "dev" ]; then
    directories=(.config .local .wallpaper)
    files=(.current_wallpaper .hushlogin .zprofile .zsh_aliases .zshrc)

    for dir in "${directories[@]}"; do
        if [ -d "$HOME/hyprland-configuration-rootfs/.config" ]; then
            _installSymLink $dir ~/$dir $HOME/hyprland-configuration-rootfs/config/$dir ~/
        fi
    done

    for file in "${files[@]}"; do
        if [ -f "$HOME/hyprland-configuration-rootfs/config/$version/$file" ]; then
            _installSymLink $file ~/$file $HOME/hyprland-configuration-rootfs/$file ~/
        fi
    done
else
    echo "Skipped: DEV MODE!"
fi
echo "Symbolic links created."
echo ""

