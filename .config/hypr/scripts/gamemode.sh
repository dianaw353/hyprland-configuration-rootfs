HYPRGAMEMODE=$(hyprctl getoption animations:enabled | sed -n '2p' | awk '{print $2}')
if [ $HYPRGAMEMODE = 1 ] ; then
    hyprctl --batch "\
        keyword animations:enabled 0;\
        keyword decoration:drop_shadow 0;\
        keyword decoration:blur:enabled 0;\
        keyword general:gaps_in 0;\
        keyword general:gaps_out 0;\
        keyword general:border_size 3;\
        keyword decoration:rounding 0"
    notify-send "󰮃 Entering gaming mode"
    exit
else
    notify-send "󰮃 Leaving gaming mode"
fi
hyprctl reload

