# Matt's Dotfiles for Miracle on Ubuntu
These dotfiles are tailored for [miracle-wm](https://github.com/miracle-wm-org/miracle-wm)
on Ubuntu 24.04. The installation is geared toward Ubuntu 24.04 users, but you may extend
it to include whatever you personally like. These dotfiles are very much geared towards
my (corporate-ish) development life that largely revolves around C++, web, python,
and other types of development.

Some dependencies that are not packaged in the Ubuntu archive are built from
source here.

I very much enjoy Dracula theming, so that's what you'll be getting if you
install this 🧛

## Screenshot

## Software
- [swaylock](https://github.com/swaywm/swaylock) for lockscreen
- [swww](https://github.com/LGFae/swww) for wallpaper
- [nwg-bar](https://github.com/nwg-piotr/nwg-bar) for logout bar
- [nwg-panel](https://github.com/nwg-piotr/nwg-panel) for top and bottom panel
- [kitty](https://sw.kovidgoyal.net/kitty/) for terminal
- [fish](https://fishshell.com/) for shell
- [grimshot](https://man.archlinux.org/man/grimshot.1.en) for screenshots
- [nm-connection-manager](https://wiki.gnome.org/Projects/NetworkManager) for network control
- [bat](https://github.com/sharkdp/bat) for better `cat`
- [newsboat](https://github.com/newsboat/newsboat) for RSS reading

## Fonts
- [Iosevka](https://github.com/be5invis/Iosevka)
- [JetBrains Mono](https://www.jetbrains.com/lp/mono/)

## Install
First, clone the repo:
```sh
git clone https://git.matthewkosarek.xyz/dotfiles.git/
```

Next, install:
```sh
cd dotfiles
./install.sh
```

## Resources
This configuration looks for resources at the following directories:
- `~/.local/share/m
