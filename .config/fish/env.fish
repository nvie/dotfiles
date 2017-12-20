# This file is sourced on login shells only (responsible for setting up the
# initial environment)

set -gx PATH /bin
append-to-path /sbin
append-to-path /usr/bin
append-to-path /usr/sbin
append-to-path ~/bin
append-to-path ~/.local/bin
append-to-path ~/Projects/syncfrom
append-to-path /usr/X11R6/bin
prepend-to-path /usr/local/sbin
prepend-to-path /usr/local/bin


# Python {{{

set -gx PIP_DOWNLOAD_CACHE ~/Library/Caches/pip-downloads

# Add more Python versions on the PATH (pypy and python3)

# Put Postgres.app's command line tools on the PATH
append-to-path /Applications/Postgres.app/Contents/Versions/9.5/bin

# }}}

# Set locale
set -gx LC_ALL en_US.UTF-8
set -gx LANG en_US.UTF-8
