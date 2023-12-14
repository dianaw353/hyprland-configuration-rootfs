if [ ! $mode == "dev" ]; then
    directories=(.config .local .wallpaper)
    files=(.current_wallpaper .hushlogin .zprofile .zsh_aliases .zshrc)

    for dir in "${directories[@]}"; do
        if [ -d "$HOME/hyprland-configuration-rootfs/$version/$dir" ]; then
            echo "Creating symbolic link for directory: $dir"
            _installSymLink $dir ~/$dir $HOME/hyprland-configuration-rootfs/config/$dir ~/
        else
            echo "Directory does not exist: $dir"
        fi
    done

    for file in "${files[@]}"; do
        if [ -f "$HOME/hyprland-configuration-rootfs/$version/$file" ]; then
            echo "Creating symbolic link for file: $file"
            _installSymLink $file ~/$file $HOME/hyprland-configuration-rootfs/config/$file ~/
        else
            echo "File does not exist: $file"
        fi
    done
else
    echo "Skipped: DEV MODE!"
fi
echo "Symbolic links created."
echo ""

