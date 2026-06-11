#!/bin/bash

# swww/swww-daemon are installed to ~/.cargo/bin, which is not on the systemd
# --user PATH that miracle-wm's startup apps inherit. Add it explicitly so this
# works at login, not just from an interactive shell.
export PATH="$HOME/.cargo/bin:$PATH"

# Starts the swww daemon and incrementally rotates through the Dracula 4K art set
# (downloaded to ~/.local/share/wallpapers/rotation by scripts/assets.sh), applying
# a pleasant transition on each change.

ROTATION_DIR="$HOME/.local/share/wallpapers/rotation"
INTERVAL_SECONDS=900           # how long each wallpaper is shown (15 minutes)
TRANSITION_TYPE="random"       # fade, wipe, grow, outer, random, ...
TRANSITION_DURATION=2
TRANSITION_FPS=60

# Start the daemon and wait until it is ready to accept commands.
swww-daemon &
until swww query >/dev/null 2>&1; do
    sleep 0.3
done

# Rotate forever, stepping through the images in sorted order.
while true; do
    shopt -s nullglob
    images=("$ROTATION_DIR"/*)
    shopt -u nullglob

    if [ ${#images[@]} -eq 0 ]; then
        # Nothing to show yet; check again shortly.
        sleep "$INTERVAL_SECONDS"
        continue
    fi

    for image in "${images[@]}"; do
        swww img "$image" \
            --transition-type "$TRANSITION_TYPE" \
            --transition-duration "$TRANSITION_DURATION" \
            --transition-fps "$TRANSITION_FPS"
        sleep "$INTERVAL_SECONDS"
    done
done
