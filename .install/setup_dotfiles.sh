_setupDotfiles() {
  echo "Changes LIBSEAT_BACKEND to logind"
  echo 'LIBSEAT_BACKEND=logind' | sudo tee -a /etc/environment
}
_zshShell() {
  echo "switching to zsh shell"
  chsh -s /bin/zsh
}
_removegtkWindowButtons() {
  echo "Removing gtk window buttons as you can exit faster using SUPER + Q"
  gsettings set org.gnome.desktop.wm.preferences button-layout ''  
}
