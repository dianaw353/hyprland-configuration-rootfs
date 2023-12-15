# dependencies.sh

# hyprland_installation.sh
_installHyprlandPackages() {
    while IFS= read -r pkg
    do
        if pacman -Qs $pkg > /dev/null ; then
            echo "The package $pkg is already installed"
        else
            echo "Installing $pkg"
            paru -S --noconfirm $pkg
        fi
    done < .install/packages.txt
}
