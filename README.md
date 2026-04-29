# Matt's Dotfiles for Miracle on Ubuntu 25.10
These dotfiles are tailored for [miracle-wm](https://github.com/miracle-wm-org/miracle-wm)
on Ubuntu 26.04. These dotfiles are very much geared towards
my (corporate-ish) development life that largely revolves around C++, web, python,
and other types of development.

Some dependencies that are not packaged in the Ubuntu archive are built from
source here.

I very much enjoy Dracula theming, so that's what you'll be getting if you
install this 🧛

Note that this configuration will only work with the latest version of miracle-wm in the
repository, so this is more of a rolling release than anything.

## Screenshot

## Software
- [swaylock](https://github.com/swaywm/swaylock) for lockscreen
- [swaybg](https://github.com/swaywm/swaybg) for wallpaper
- [swaync](https://github.com/ErikReider/SwayNotificationCenter) for notifications
- [wofi](https://github.com/SimplyCEO/wofi): for launcher
- [waybar](https://github.com/Alexays/Waybar) for top panel
- [kitty](https://sw.kovidgoyal.net/kitty/) for terminal
- [wlogout](https://github.com/ArtsyMacaw/wlogout) for logout
- [fish](https://fishshell.com/) for shell
- [Oh My Fish](https://github.com/oh-my-fish/oh-my-fish) for fish shell framework
- [bobthefish](https://github.com/oh-my-fish/theme-bobthefish) for fish theming
- [grimshot](https://man.archlinux.org/man/grimshot.1.en) for screenshots
- [nm-connection-manager](https://wiki.gnome.org/Projects/NetworkManager) for network control
- [bat](https://github.com/sharkdp/bat) for better `cat`
- [fdfind](https://github.com/sharkdp/fd) for better `find`
- [newsboat](https://github.com/newsboat/newsboat) for RSS reading
- [pamixer](https://github.com/cdemoulins/pamixer) for volume adjustment
- [brightnessctl](https://github.com/Hummer12007/brightnessctl) for brightness
  management
- [wl-clipboard](https://github.com/bugaevc/wl-clipboard) for copy
- [pavucontrol](https://gitlab.freedesktop.org/pulseaudio/pavucontrol) for sound control
- [nautilus](https://gitlab.gnome.org/GNOME/nautilus) for file management

## Fonts
- [Iosevka](https://github.com/be5invis/Iosevka)
- [JetBrains Mono Nerd](https://github.com/ryanoasis/nerd-fonts)

## Icons
- [Papirus Icon Theme](https://github.com/PapirusDevelopmentTeam/papirus-icon-theme)

## Requirements

**Ubuntu 26.04 is required.** The install script will exit immediately if run on any other OS or version.

## Install

> [!CAUTION]
> **Only install on a fresh machine.** This script is destructive — it will overwrite your existing dotfiles, shell configuration, and system packages without the ability to recover them. Do **not** run this on a machine with configuration you care about.

First, clone the repo:
```sh
git clone git@github.com:mattkae/dotfiles.git
```

Next, run the `install` script:

```sh
./install.sh [OPTIONS]
```

The script always installs dependencies, miracle-wm, fonts, and screenshare support. Optional flags:

```
Options:
  --yes                   Skip confirmation prompt
  --help                  Show this help message and exit
```

## Directories
- `~/.local/bin`: local scripts
- `~/.local/src`: local source projects
- `~/.local/share/wallpapers`: images for background and lockscreen

## Configurations
The primary configuration is `~/.config/miracle-wm/config.yaml`. Users may place
any machine-specific configuration in `~/config/miracle-wm/user-config.yaml`.
For example, I run `xdg-desktop-portal-wlr` there so that screensharing works.

## Fish
- Users may add custom fish configuration in `~/.config/fish/user.sh`.
