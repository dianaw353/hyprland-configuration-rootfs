sh hyprland.sh && echo "goodbye, now logging out" && exit 0 \
 || echo "$? hyperland.sh failed" && tty |grep tty1 \
  && echo "refusing autologin without hyprland on tty1" && exit 0 \
  || echo "not on tty1, letting in"
