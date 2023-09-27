if [[ "$(tty)" == "/dev/tty1" ]]
 then
  sh hyprland.sh && echo "goodbye, now logging out" && exit 0 \
   || echo "$? hyperland.sh failed" && tty |grep tty1 \
    && echo "refusing autologin without hyprland on tty1" && exit 0 \
    || echo "not on tt1, letting in"
fi
