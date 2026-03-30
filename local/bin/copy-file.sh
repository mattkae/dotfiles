#!/bin/bash

# Check if a filename was provided
if [ -z "$1" ]; then
    echo "Usage: ./copy-file.sh <filename>"
    exit 1
fi

# Determine which clipboard tool is available and copy
if command -v wl-copy > /dev/null; then
    batcat -p "$1" | wl-copy
    echo "Copied to clipboard (wl-copy)."
elif command -v xclip > /dev/null; then
    batcat -p "$1" | xclip -selection clipboard
    echo "Copied to clipboard (xclip)."
elif command -v pbcopy > /dev/null; then
    batcat -p "$1" | pbcopy
    echo "Copied to clipboard (pbcopy)."
else
    echo "Error: No supported clipboard manager (xclip, wl-copy, or pbcopy) found."
    exit 1
fi
