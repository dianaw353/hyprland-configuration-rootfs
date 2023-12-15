_installGitPackages() {
  git clone https://github.com/dianaw353/wttrbar.git -b develop
    cd wttrbar
    cargo build --release
    sudo install target/release/wttrbar /usr/local/bin/
    cd ~/hyprland-configuration-rootfs
    git clone https://github.com/CameronNemo/brillo.git -b trunk --depth=1 --no-tags
    cd brillo
    make
    sudo make install.setgid
    cd ~/hyprland-configuration-rootfs
    echo "Removing packages build files"
    rm -rf wttrbar
    rm -rf brillo
}
