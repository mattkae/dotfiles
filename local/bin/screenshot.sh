#!/bin/bash
mkdir -p ~/Pictures/Screenshots
FILE=~/Pictures/Screenshots/$(date +%Y-%m-%d_%H-%M-%S).png
grimshot save area "$FILE"
wl-copy < "$FILE"
notify-send "Screenshot saved" "$FILE" --icon=camera
