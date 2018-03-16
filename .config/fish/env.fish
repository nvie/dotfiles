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
append-to-path /usr/X11R6/bin
prepend-to-path /usr/local/sbin
prepend-to-path /usr/local/bin


# Python {{{

set -gx PIP_DOWNLOAD_CACHE ~/Library/Caches/pip-downloads

# Python 2 support
prepend-to-path (pyenv root)/shims

# Put Postgres.app's command line tools on the PATH
append-to-path /Applications/Postgres.app/Contents/Versions/9.5/bin

# }}}

# Set locale
set -gx LC_ALL en_US.UTF-8
set -gx LANG en_US.UTF-8

# Configure fzf to use fd by default (fd respects .gitignore defaults)
set -gx FZF_DEFAULT_COMMAND 'fd --type f'
