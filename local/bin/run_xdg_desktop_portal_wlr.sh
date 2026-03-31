# /usr/local/bin/run_xdg_desktop_portal_wlr.sh

# Export WAYLAND_DISPLAY and XDG_CURRENT_DESKTOP to dbus
dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP=mir

# Stop xdg-desktop-portal
systemctl --user stop xdg-desktop-portal

# Also, you may want do stop any other portal service that you have enabled, e.g.:
systemctl --user stop xdg-desktop-portal-gtk

# Start xdg-desktop-portal-*
systemctl --user start xdg-desktop-portal
systemctl --user start xdg-desktop-portal-wlr
