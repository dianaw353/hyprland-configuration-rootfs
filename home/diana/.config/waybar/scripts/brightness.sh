#!/bin/bash
brightness=$(brillo -G)
brightness_rounded=$(printf "%.0f" $brightness)
echo "{\"text\":\"$brightness_rounded%\"}"

