# Matt's Dotfiles for Miracle on Ubuntu
These dotfiles are tailored for [miracle-wm](https://github.com/miracle-wm-org/miracle-wm)
on Ubuntu 25.10. The installation is geared toward Ubuntu 25.10 users, but you may extend
it to include whatever you personally like. These dotfiles are very much geared towards
my (corporate-ish) development life that largely revolves around C++, web, python,
and other types of development.

Some dependencies that are not packaged in the Ubuntu archive are built from
source here.

I very much enjoy Dracula theming, so that's what you'll be getting if you
install this 🧛

Note that this configuration will only work with the latest version of miracle in the
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
- [brightnessctl](https://github.com/Hummer12007/brightnessctl) for brightness management

## Fonts
- [Iosevka](https://github.com/be5invis/Iosevka)
- [JetBrains Mono Nerd](https://github.com/ryanoasis/nerd-fonts)

## Icons
- [Papirus Icon Theme](https://github.com/PapirusDevelopmentTeam/papirus-icon-theme)

## Install
First, clone the repo:
```sh
git clone git@github.com:mattkae/dotfiles.git
```

**WARNING**: This next step will be destructive to existing configuration files,
so please run at your own risk.

Next, install:

```sh
cd dotfiles
./install.sh [--install-deps] [--install-fonts]
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
- Users may play custom fish configuration in `~/.config/fish/user.sh`.