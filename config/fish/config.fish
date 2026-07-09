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
fish_add_path "$HOME/.local/share/flutter/bin"
fish_add_path "$HOME/.bun/bin"

function ssh --wraps 'kitty +kitten ssh'
    # Count positional (non-flag) args, skipping the value of value-taking options.
    set -l value_opts b c D E e F I i J L l m O o p Q R S W w
    set -l positional 0
    set -l skip_next no
    for arg in $argv
        if test $skip_next = yes
            set skip_next no
            continue
        end
        if string match -q -- '-*' $arg
            # If this flag takes a separate value (e.g. -p 2222), skip that value.
            set -l last (string sub -s -1 -- $arg)
            if contains -- $last $value_opts; and test (string length -- $arg) -eq 2
                set skip_next yes
            end
        else
            set positional (math $positional + 1)
        end
    end

    if test $positional -eq 1
        # Interactive login: just the host, no remote command.
        # Use fish on the remote if present, otherwise the account's default shell.
        command kitty +kitten ssh -t $argv 'command -v fish >/dev/null 2>&1 && exec fish -l || exec $SHELL -l'
    else
        command kitty +kitten ssh $argv
    end
end
