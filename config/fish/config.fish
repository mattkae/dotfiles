set -g theme_powerline_fonts no
set -g theme_nerd_fonts yes
set -g theme_color_scheme dracula

if status is-interactive
    fastfetch
end

if test -f ~/.config/fish/user.fish
    source ~/.config/fish/user.fish
end

alias fd="fdfind"
alias cat="batcat"
alias ls="eza --icons --group-directories-first"
fish_add_path "$HOME/.local/bin"
