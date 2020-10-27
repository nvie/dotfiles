# This file is sourced on login shells only (responsible for setting up the
# initial environment)

set -gx PATH /bin
append-to-path /sbin
append-to-path /usr/bin
append-to-path /usr/sbin
append-to-path ~/bin
append-to-path ~/.local/bin
append-to-path ~/Projects/syncfrom
append-to-path ~/Projects/git-toolbelt
prepend-to-path /usr/local/sbin
prepend-to-path /usr/local/bin

# Old MySQL version (5.7)
append-to-path /usr/local/Cellar/mysql@5.7/5.7.32/bin

# Old MongoDB version (3.0) for Sleutelzorg/Heroku
append-to-path /usr/local/opt/mongodb@3.0/bin

# Python: source pyenv config for fish
set -gx PIP_DOWNLOAD_CACHE ~/Library/Caches/pip-downloads
pyenv init - fish | source

# Set locale
set -gx LC_ALL en_US.UTF-8
set -gx LANG en_US.UTF-8

# Configure fzf to use fd by default (fd respects .gitignore defaults)
set -gx FZF_DEFAULT_COMMAND 'fd --type f'
