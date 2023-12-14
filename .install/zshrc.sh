# ------------------------------------------------------
# Install ..zshrc
# ------------------------------------------------------
echo -e "${GREEN}"
cat <<"EOF"
   _               _              
  | |__   __ _ ___| |__  _ __ ___ 
  | '_ \ / _` / __| '_ \| '__/ __|
 _| |_) | (_| \__ \ | | | | | (__ 
(_)_.__/ \__,_|___/_| |_|_|  \___|
EOF
echo -e "${NONE}"
if [ ! -L ~/.zshrc ] && [ -f ~/.zshrc ]; then
    echo "PLEASE NOTE AGAIN: The script has detected an existing .zshrc file."
fi
if [ -f ~/hyprland-configuration-rootfs-versions/backups/$datets/.zshrc-old ]; then
    echo "Backup is already available here ~/hyprland-configuration-rootfs-versions/backups/$datets/..zshrc-old"
fi
if [ ! -L ~/.zshrc ] && [ -f ~/.zshrc ]; then
    zsh_confirm="Do you want to replace your existing .zshrc file with the dotfiles .zshrc file?"
else
    zsh_confirm="Do you want to install the dotfiles .zshrc file now?"
fi
if gum confirm "$bash_confirm" ;then
    _installSymLink .zshrc ~/.zshrc ~/hyprland-configuration-rootfs
/.zshrc ~/.zshrc
elif [ $? -eq 130 ]; then
        exit 130
else
    echo "Installation of the .zshrc file skipped."
fi
echo ""
