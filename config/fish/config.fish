set -g theme_powerline_fonts no
set -g theme_nerd_fonts yes
set -g theme_color_scheme dracula
# set -g theme_display_git no

# These are special systems to make Mir symbols generation work
export MIR_SYMBOLS_MAP_GENERATOR_CLANG_SO_PATH=/usr/lib/llvm-19/lib/libclang-19.so.1
export MIR_SYMBOLS_MAP_GENERATOR_CLANG_LIBRARY_PATH=/usr/lib/llvm-19/lib

export PATH="$PATH:$HOME/.local/bin:$HOME/Github/flutter/bin:$HOME/Programs/depot_tools"

# Export flutter as an environment variable
export FLUTTER="$HOME/Github/flutter/bin/flutter"
