if [ ! $mode == "dev" ]; then
    directories=(.config .local .wallpaper)
    files=(.current_wallpaper .hushlogin .zprofile .zsh_aliases .zshrc)

    for dir in "${directories[@]}"; do
        if [ -d "$HOME/hyprland-configuration-rootfs/$version/$dir" ]; then
            echo "Copying directory: $dir"
            cp -r $HOME/hyprland-configuration-rootfs/$version/$dir ~/
        else
            echo "Directory does not exist: $dir"
        fi
    done

    for file in "${files[@]}"; do
        if [ -f "$HOME/hyprland-configuration-rootfs/$version/$file" ]; then
            echo "Copying file: $file"
            cp $HOME/hyprland-configuration-rootfs/$version/$file ~/
        else
            echo "File does not exist: $file"
        fi
    done
else
    echo "Skipped: DEV MODE!"
fi
echo "Files and directories copied."
echo ""

