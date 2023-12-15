_execute_premissions() {
    echo -e "${GREEN}"
    figlet "Additonal Dotfiles Scripts"
    echo -e "${NONE}"
    sudo chmod +x ~/.local/bin/*
    chmod +x ~/.config/hypr/scripts/*
    chmod +x ~/.config/waybar/scripts/*
}
