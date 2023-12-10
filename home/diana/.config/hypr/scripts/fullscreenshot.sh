sh -c 'FILE=~/Pictures/screenshots/$(date +%Y-%m-%d_%H:%M:%S).png; grim $FILE && notify-send -i $FILE "Screenshot taken and saved at $FILE"'
