# This file is sourced on login shells only (responsible for setting up the
# initial environment)

set -gx PATH /bin

append-to-path /sbin
append-to-path /usr/bin
append-to-path /usr/local/bin
append-to-path /usr/sbin
append-to-path ~/bin
append-to-path ~/.local/bin
append-to-path ~/.cargo/bin
append-to-path ~/Projects/syncfrom
append-to-path ~/Projects/git-toolbelt
append-to-path ~/Projects/linenos/bin
append-to-path "/Applications/Ghostty.app/Contents/MacOS"
append-to-path ~/Projects/liveblocks/liveblocks/scripts

# Bun
set --export BUN_INSTALL "$HOME/.bun"
append-to-path "$BUN_INSTALL/bin"

# pnpm
set -gx PNPM_HOME "$HOME/Library/pnpm"

# prepend-to-path /opt/homebrew/opt/node@18/bin
prepend-to-path /opt/homebrew/sbin
prepend-to-path /opt/homebrew/bin
prepend-to-path /opt/homebrew/opt/postgresql@17/bin

# Old MySQL version (5.7)
# append-to-path /opt/homebrew/Cellar/mysql@5.7/5.7.37/bin

# Old MongoDB version (3.0) for Sleutelzorg/Heroku
# append-to-path /usr/local/opt/mongodb@3.0/bin

# Python: source pyenv config for fish
set -gx PIP_DOWNLOAD_CACHE ~/Library/Caches/pip-downloads
set -Ux PYENV_ROOT $HOME/.pyenv
status is-login; and pyenv init --path | source
pyenv init - | source

# Set locale
set -gx LC_ALL en_US.UTF-8
set -gx LANG en_US.UTF-8

# Configure fzf to use fd by default (fd respects .gitignore defaults)
set -gx FZF_DEFAULT_COMMAND 'fd --type f --hidden --exclude .git'
