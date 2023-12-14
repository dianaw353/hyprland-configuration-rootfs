sh -c 'FILE=~/Pictures/screenshots/$(date +%Y-%m-%d_%H:%M:%S).png; grim -g "$(slurp)" $FILE && notify-send -i $FILE "Screenshot taken and saved at $FILE"'
