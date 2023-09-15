#!/bin/sh
# Definitely replace the following path if you're not a laptop user.
[ ! -f /run/udev/data/+drm:card0-eDP-1 ] \
 && sudo systemctl restart systemd-udev-trigger > /dev/null

sudo systemctl status iwd|grep Active..active \
 || sudo systemctl start iwd &

# This path too.
while [ ! -f /run/udev/data/+drm:card0-eDP-1 ] ; do echo "waiting for drm" && sleep 0.2 ; done

# Replace with your username here btw.
export USER=beru
[ -z $TERM ] && export TERM=linux
[ -z $LOGNAME ] && export LOGNAME=$USER
[ -z $HOME ] && export HOME=/home/$USER
[ -z $LANG ] && export LANG=C.UTF-8
[ -z $PATH ] && export PATH=/usr/local/sbin:/usr/local/bin:/usr/bin:/usr/bin/site_perl:/usr/bin/vendor_perl:/usr/bin/core_perl
[ -z $XDG_SEAT ] && export XDG_SEAT=seat0
[ -z $XDG_SESSION_TYPE ]  && export XDG_SESSION_TYPE=tty
[ -z $XDG_SESSION_CLASS ] && export XDG_SESSION_CLASS=user
[ -z $XDG_VTNR ] && export XDG_VTNR=1
# Check the contents of /run/user while at it and replace if necessary.
[ -z $XDG_RUNTIME_DIR ] && export XDG_RUNTIME_DIR=/run/user/1000
[ -z $DBUS_SESSION_BUS_ADDRESS ] && export DBUS_SESSION_BUS_ADDRESS=unix:path=/run/user/1000/bus

export HYPRLAND_LOG_WLR=1
export XCURSOR_SIZE=24

# VM optimizations right here. Uncomment these if you're testing on a VM. Hyprland will lag so hard if you do not.
# export WLR_NO_HARDWARE_CURSORS=1
# export WLR_RENDERER_ALLOW_SOFTWARE=1

# change the theme here
export XCURSOR_THEME=Adwaita
export GTK_THEME=Adwaita-dark

# And finally this path here as well.
[ ! -f /run/udev/data/+drm:card0-eDP-1 ] \
 && echo "Hyprland needs drm, bailing out" && exit -1

exec Hyprland > $HOME/.hyprland.log.txt 2> $HOME/.hyprland.err.txt
