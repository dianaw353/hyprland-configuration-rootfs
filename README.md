<div align="center">
<h1>Hyprland configurations rootfs structure</h1>
</div>
<div align="center">
    
![GitHub last commit (branch)](https://img.shields.io/github/last-commit/dianaw353/hyprland-configuration-rootfs/mistress?style=for-the-badge&labelColor=%23252733&color=%238d748c)
![GitHub Repo stars](https://img.shields.io/github/stars/dianaw353/hyprland-configuration-rootfs?style=for-the-badge&labelColor=%23252733&color=%23ab6c6a)
![GitHub repo size](https://img.shields.io/github/repo-size/dianaw353/hyprland-configuration-rootfs?style=for-the-badge&labelColor=%23252733&color=%23ddddbb)
![GitHub issues](https://img.shields.io/github/issues/dianaw353/hyprland-configuration-rootfs?style=for-the-badge&labelColor=%23252733&color=%235e81ac)
</div>

## Alright, now tell me what this structure exactly does.

1. Logs in automatically as the user `Diana`.
2. Launches Hyprland as the user logged in on boot.
3. If, in any case, Hyprland exits, it will prevent exposing your autologin shell and drop back to login prompt on TTY1.
4. Configures SwayLock with the config from https://gitlab.com/stephan-raabe/dotfiles/-/blob/main/swaylock/config.
5. Configurs swayidle so it locks after x amount of time
6. Configures swayidle to lock devide when lid is shut
7. Hypr bind configs for sound and player buttons
9. waybar basic config
10. desktop notificications 


## Wait, but my system configuration doesn't match with yours!

Check all files, inspect your system and replace everything that
doesn't match with your system. Such as replacing all instances of
`botan` with `andrew`.

## How about my existing SwayLock config?

It will be overwritten! Make sure to back it up before applying this
rootfs repo!

## Needed Packages

If you're using Arch or its derivative, install the following packages
using an AUR helper to avoid problems from missing packages;

## Recommended Dependencies for All Arch Linux Systems

| Programs      | Description |
| ----------- | ----------- |
| base| Minimal package set|
| linux | Default kernel |
| linux-firmware | default firmware |
| linux-lts | Backup kernel |

## Recommended optional dependencies for Linux 

| Programs      | Description |
| ----------- | ----------- |
| exa | Modern replacement for ‘ls’ |
| booster | Fast and secure initramfs generator |
| zoxide | Smart version of 'cd' |
| ripgrep | Faster version of 'grep'|
| xdg-user-dirs| Creates default user home directory |
| paru | AUR wrapper |

Instructions to use booster,zoxide,exa,repgrip,peru coming soon

## Hyprland Rice Dependencies

| Programs      | Description |
| ----------- | ----------- |
| Hyprland      | Tiling Manager |
| Swww   | Wallpaper Manager |
| xdg-desktop-portal-hyprland |Lets other applications communicate swiftly with the compositor through D-Bus |
| rofi-lbonn-wayland-git | Window switcher, application launcher and dmenu replacement |
| waybar-hyprland | Highly customizable Wayland bar for Sway and Wlroots based compositors, with Hyprland support |
| wlogout | Logout menu for wayland |
| swaylock-effects| fancier screen locker |
| swayidle | Idle management daemon |
| wttrbar | Weather indicator for Waybar |
| cliphist | wayland clipboard manager |
| grim | Screenshot utility for Wayland |
| slurp | Select a region in a Wayland compositor |
| zsh | A very advanced and programmable command interpreter (shell) | 
| starship | The cross-shell prompt for astronauts |
| mako | Lightweight notification daemon  |
| libnotify | Library for sending desktop notifications |

## TUI Programs

| Programs      | Description |
| ----------- | ----------- |
| helix | A post-modern modal text editor |
| helixbinhx | Link /usr/bin/hx to helix |
| pfetch-rs-bin | A rewrite of the pfetch system information tool in Rust |
| bottom | System monitor written in rust |
| dua-cli | A tool to conveniently learn about the disk usage of directories, fast! |
| todui | A TUI for your todos built in Rust with full CLI support |
| rsmixer | A PulseAudio volume mixer for the command line | 
| networkmanager | Network connection manager and user applications |
| playerctl | mpris media player controller and lib for spotify, vlc, audacious, bmp, xmms2, and others. |
| brillo | Control the brightness of backlight and keyboard LED devices |

## GUI Programs

| Programs      | Description |
| ----------- | ----------- |
| alacritty | A cross-platform, GPU-accelerated terminal emulator |
| mupdf | Lightweight PDF and XPS viewer |
| nautilus | File manager |
| librewolf-bin | Community-maintained fork of Firefox, focused on privacy, security and freedom. |

## Sound dependencies

| Programs      | Description |
| ----------- | ----------- |
| pipewire | Low-latency audio/video router and processor |
| pipewire-alsa | Low-latency audio/video router and processor - ALSA configuration | 
| pipewire-audio | Low-latency audio/video router and processor - Audio support | 
| pipewire-jack | Low-latency audio/video router and processor - JACK replacement |
| wireplumber | Session / policy manager implementation for PipeWire |
| gst-plugin-pipewire | Multimedia graph framework - pipewire plugin |
| pipewire-pulse | Low-latency audio/video router and processor - PulseAudio replacement |
| bluez | Daemons for the bluetooth protocol stack |
| bluez-utils | Development and debugging utilities for the bluetooth protocol stack |

## System Fonts

| Programs      | Description |
| ----------- | ----------- |
| gnu-free-fonts| This includes three fonts that are clones of Helvetica, Times, and Courier1 |
| ttf-fira-sans | Mozilla's sans-serif typeface designed for Firefox OS |
| ttf-font-awesome | This is an iconic font designed for Bootstrap |
| ttf-nerd-fonts-symbols-mono | This is a high number of extra glyphs from popular 'iconic fonts’ |
| noto-fonts-emoji | These are Google Noto emoji fonts |
| adobe-source-code-pro-fonts | This is a monospaced font family for user interface and coding environments | 
| adobe-source-han-sans-jp-fonts | This is Adobe Source Han Sans Subset OTF - Japanese OpenType/CFF fonts7. |
| adobe-source-han-serif-kr-fonts |	Adobe Source Han Serif Subset OTF - Korean OpenType/CFF fonts |
| ttf-jetbrains-mono-nerd | This is a patched font JetBrains Mono from the nerd fonts library |
| ttf-nerd-fonts-symbols | This is a high number of extra glyphs from popular 'iconic fonts’ |
| ttf-nerd-fonts-symbols-common | This is a high number of extra glyphs from popular 'iconic fonts’ |

# Helix laguage servers
We use these packages so that we get drowpdowns in helix to help us program

| Programs      | Description |
| ----------- | ----------- |
| marksman | Write Markdown with code assist and intelligence in the comfort of your favourite editor. |
| bash-language-server | Bash language server implementation based on Tree Sitter and its grammar for Bash |
| vscode-css-languageserver | CSS/LESS/SCSS language server |
| vscode-html-languageserver | HTML language server |
| rust-analyzer | Rust compiler front-end for IDEs |
| lldb | Next generation, high-performance debugger |

If you're not using Arch, you'll have to look for these packages individually.

### Recommended way to install on Arch

```bash
sudo pacman -S git 
git clone https://aur.archlinux.org/paru-bin --depth=1
cd paru-bin
makepkg -si
paru -S hyprland swww xdg-desktop-portal-hyprland \
    helix helixbinhx pfetch-rs-bin bottom alacritty starship zsh \
    swaylock-effects swayidle cliphist xdg-user-dirs marksman \
    ttf-fira-sans ttf-nerd-fonts-symbols-mono gnu-free-fonts noto-fonts-emoji \
    playerctl mako libnotify pipewire pipewire-alsa pipewire-audio ripgrep \
    pipewire-jack wireplumber gst-plugin-pipewire librewolf-bin zoxide \
    waybar-hyprland bluez bluez-utils adobe-source-code-pro-fonts \
    adobe-source-han-sans-jp-fonts adobe-source-han-serif-kr-fonts \
    ttf-font-awesome mupdf nautilus ttf-jetbrains-mono-nerd dua-cli \
    ttf-nerd-fonts-symbols-common ttf-nerd-fonts-symbols unzip networkmanager \
    go-md2man rofi-lbonn-wayland-git bluetuith grim slurp wlogout linux-lts \
    rsmixer pipewire-pulse wttrbar bash-language-server vscode-css-languageserver \
    vscode-html-languageserver rust-analyzer lldb

```

## Installation instructions

Make sure you're logged in as the user who will use Hyprland.

```bash
git clone https://github.com/diana353/hyprland-configuration-rootfs
cd hyprland-configuration-rootfs
mv home/botan home/$(whoami)
cp -r home/$(whoami)/.config ~/
mkdir ~/.local && mkdir ~/.local/bin
mkdir ~/Pictures/screenshots
cp -r /home/$(whoami)/.local ~/
cp -r /home/$(whoami)/.wallpaper ~/
cp -r /home/$(whoami)/.* ~/
sudo cp etc/systemd/system/getty@tty1.service /etc/systemd/system/
echo 'LIBSEAT_BACKEND=logind' | sudo tee -a /etc/environment
chmod +x ~/.config/hypr/scripts/*
sudo systemctl enable getty@tty1.service
sudo systemctl enable bluetooth.service
chsh -s /bin/zsh
cd
git clone https://github.com/CameronNemo/brillo.git -b trunk --depth=1 --no-tags
cd brillo
make
sudo make install.setgid
git clone https://github.com/vinceliuice/Orchis-theme.git --depth=1 --no-tags
cd Orchis-theme
./install.sh -c dark -t pink -l
# remove gtk window buttons
gsettings set org.gnome.desktop.wm.preferences button-layout ''  
https://github.com/danimelchor/todui.git
cargo install todui  
```

## update brillo

To update brillo please do the following:

```bash
cd brillo
git pull origin trunk
make
```
## System Keybinds

| Keybind                | Action Description                                                                |
|------------------------|------------------------------------------------------------------------------------|
| SUPER + ALT + P        | Open/change wallpaper using the script `~/.config/hypr/scripts/change_wallpaper.sh`|
| SUPER + T              | Open terminal emulator `alacritty`                                                     |
| SUPER + W              | Open web browser `librewolf`                                                      |
| SUPER + Q              | Close/kill the active window                                                      |
| SUPER + CTRL + M       | Exit the current application/window                                               |
| SUPER + E              | Open file manager `nautilus` in a new window                                       |
| SUPER + V              | Toggle floating for the active window                                              |
| SUPER + SPACE          | Open application launcher (`rofi -show drun -show-icons`)                          |
| SUPER + P              | Pseudo command for `# dwindle` (commented)                                         |
| SUPER + J              | Toggle split for `# dwindle` (commented)                                           |
| SUPER + F              | Toggle fullscreen for the active window (1)                                       |
| SUPERSHIFT + F         | Toggle fullscreen for the active window                                            |
| SUPER + arrow keys     | Move focus in the specified direction                                              |
| SUPER + , print        | Take a screenshot and display a notification with the file path                    |
| SUPERSHIFT + , print   | Take a screenshot of the selected area and display a notification with the file path|
| SUPERSHIFT + C         | Copy the selected item using `cliphist` and display with `rofi`                    |
| SUPER + SHIFT + B      | Reload Waybar                                                                      |
| SUPER + B              | Hide Waybar                                                                        |
| XF86AudioMute          | Toggle mute and display a notification                                             |
| XF86AudioRaiseVolume   | Increase volume by 5% and display a volume notification                             |
| XF86AudioLowerVolume   | Decrease volume by 5% and display a volume notification                             |
| XF86AudioPlay          | Play/pause media player                                                            |
| XF86AudioNext          | Skip to the next track                                                             |
| XF86AudioPrev          | Return to the previous track                                                       |
| XF86audiostop          | Stop the media player                                                               |
| XF86MonBrightnessDown  | Decrease brightness by 2% and display a brightness notification                     |
| XF86MonBrightnessUp    | Increase brightness by 2% and display a brightness notification                     |
| SUPER + [0-9]           | Switch to the specified workspace                                                  |
| SUPER + SHIFT + [0-9]   | Move the active window to the specified workspace                                   |
| SUPER + scroll          | Scroll through existing workspaces                                                 |
| SUPER + LMB/RMB         | Move/resize windows with dragging                                                  |
| switch:off:Lid Switch  | When the lid is up, turn on the display |
| switch:on:Lid Switch   | When the lid is down, pause music, turn off the display, and lock the screen        |
| SUPER + SHIFT + LMB     | Move window around and pin it afterwards                                           |

## Workspace keybind

| Keybind                | Action Description                                       |
|------------------------|-----------------------------------------------------------|
| SUPER + 1              | Switch to workspace 1                                    |
| SUPER + 2              | Switch to workspace 2                                    |
| SUPER + 3              | Switch to workspace 3                                    |
| SUPER + 4              | Switch to workspace 4                                    |
| SUPER + 5              | Switch to workspace 5                                    |
| SUPER + 6              | Switch to workspace 6                                    |
| SUPER + 7              | Switch to workspace 7                                    |
| SUPER + 8              | Switch to workspace 8                                    |
| SUPER + 9              | Switch to workspace 9                                    |
| SUPER + 0              | Switch to workspace 10                                   |
| SUPER + SHIFT + 1      | Move active window to workspace 1                         |
| SUPER + SHIFT + 2      | Move active window to workspace 2                         |
| SUPER + SHIFT + 3      | Move active window to workspace 3                         |
| SUPER + SHIFT + 4      | Move active window to workspace 4                         |
| SUPER + SHIFT + 5      | Move active window to workspace 5                         |
| SUPER + SHIFT + 6      | Move active window to workspace 6                         |
| SUPER + SHIFT + 7      | Move active window to workspace 7                         |
| SUPER + SHIFT + 8      | Move active window to workspace 8                         |
| SUPER + SHIFT + 9      | Move active window to workspace 9                         |
| SUPER + SHIFT + 0      | Move active window to workspace 10                        |
| SUPER + Scroll Down    | Scroll to the next workspace                              |
| SUPER + Scroll Up      | Scroll to the previous workspace                          |

## Fractional scalling fuzzy font app fix 

Edit the following command that says program_name with the program name and run the that command you have edited and once you have run that you should have a not fuzzy font experaince
```
sudo sed -i '/^Exec=/ s/\(program_name\)\(.*\)/\1 --enable-features=useozoneplatform --ozone-platform=wayland\2/' /usr/share/applications/program_name.desktop
```


## Firefox instrustions

Use the Firefox Sidebery extention with the firefox theme

browser.newtabpage.activity-stream.feeds.section.topstories.options = false
identity.fxaccounts.enabled = false
browser.preferences.moreFromMozilla = false - hides more from mozilla catagory

Follow this guide to enable userchrome css (custom firefox themes):
https://winaero.com/enable-loading-userchrome-css-usercontent-css-firefox/

Firefox theme instructions are found here
https://github.com/AmadeusWM/dotfiles-hyprland

Then reboot and watch the magic happen!

Firefox custom home page workaround so it opens in new tab.
https://peterries.net/blog/firefox-ubuntu-local-file/

Gnome firefox theme
https://github.com/dgsasha/dg-firefox-theme

## Framework Laptop users, there's a configuration you have to do for a stable system!

Create `/etc/modprobe.d/framework-als-blacklist.conf` and add the following line as its contents;

```
blacklist hid_sensor_hub
```

To put it as a command;

```bash
echo "blacklist hid_sensor_hub" | sudo tee -a /etc/modprobe.d/framework-als-blacklist.conf
```

Or this command if you use a different initial ramdisk environment like booster.

```
sudo modprobe -i hid_sensor_hub 
```

<details>
    <summary>What this does</summary>
    <p>It blacklists sensor hub so that auto brightness is prevented from working, eventually fixing brightness keys.</p>
</details>

## Nvidia users, check this out!

Hyprland has an official documentation prepared for you all! Check it
out and follow the instructions there for the most stable experience
possible!

https://wiki.hyprland.org/Nvidia/

## Additional Configurations Unrelated to Hyprland

[GRUB and boot animation configuration](./home/botan/grub-and-bootanim-configuration.mkdn)

# Resources
Thanks to everyone below and many other I forgot to add...

Main configurations and scripts: https://www.reddit.com/r/hyprland/comments/127m3ef/starting_hyprland_directy_from_systemd_a_guide_to/

Swaylock config: https://gitlab.com/stephan-raabe/dotfiles/-/blob/main/swaylock/config

