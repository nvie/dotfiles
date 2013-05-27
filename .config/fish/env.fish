# This file is sourced on login shells only (responsible for setting up the
# initial environment)

set -gx PATH /bin
append-to-path /sbin
append-to-path /usr/bin
append-to-path /usr/sbin
append-to-path ~/bin
append-to-path ~/Projects/scripts
append-to-path ~/Projects/syncfrom
append-to-path ~/Documents/Scripts
append-to-path /usr/X11R6/bin
prepend-to-path /usr/local/share/npm/bin
prepend-to-path /usr/local/sbin
prepend-to-path /usr/local/bin


# Python {{{

set -gx PIP_DOWNLOAD_CACHE ~/Library/Caches/pip-downloads
set -gx PYTHONSTARTUP ~/.pythonrc.py
set -gx WORKON_HOME ~/.virtualenvs

# Make this the default Python env
prepend-to-path ~/.virtualenvs/default/bin

# }}}


# TODO: This was in my zshrc file, and needs to find a place in my fish config {{{

#[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm"  # This loads RVM into a shell session.

#export VIRTUALENVWRAPPER_SCRIPT=/usr/local/bin/virtualenvwrapper.sh
#[[ ! -d $WORKON_HOME ]] && mkdir -p $WORKON_HOME
#source /usr/local/bin/virtualenvwrapper_lazy.sh
#source /usr/local/bin/virtualenvwrapper.sh

# }}}
