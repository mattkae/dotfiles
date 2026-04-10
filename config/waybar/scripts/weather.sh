#!/usr/bin/sh
result=$(curl -s "https://wttr.in/Philadelphia?format=1")
if echo "$result" | grep -q "render failed"; then
  exit 1
fi
echo "$result"
