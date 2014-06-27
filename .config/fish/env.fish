# This file is sourced on login shells only (responsible for setting up the
# initial environment)

set -gx PATH /bin
append-to-path /sbin
append-to-path /usr/bin
append-to-path /usr/sbin
append-to-path ~/bin
append-to-path ~/Projects/scripts
append-to-path ~/Projects/syncfrom
append-to-path ~/Projects/git-toolbelt
append-to-path ~/Documents/Scripts
append-to-path /usr/X11R6/bin
prepend-to-path /usr/local/share/npm/bin
prepend-to-path /usr/local/sbin
prepend-to-path /usr/local/bin


# Python {{{

set -gx PIP_DOWNLOAD_CACHE ~/Library/Caches/pip-downloads
set -gx PYTHONSTARTUP ~/.pythonrc.py
set -gx WORKON_HOME ~/.virtualenvs

# Add more Python versions on the PATH (pypy and python3)
append-to-path ~/.pythonz/pythons/CPython-3.4.0/bin
append-to-path ~/.pythonz/pythons/CPython-3.3.2/bin
append-to-path ~/.pythonz/pythons/PyPy-2.0.2/bin

# Put Postgres.app's command line tools on the PATH
append-to-path /Applications/Postgres.app/Contents/Versions/9.3/bin

# }}}


# TODO: This was in my zshrc file, and needs to find a place in my fish config {{{

#[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm"  # This loads RVM into a shell session.

#export VIRTUALENVWRAPPER_SCRIPT=/usr/local/bin/virtualenvwrapper.sh
#[[ ! -d $WORKON_HOME ]] && mkdir -p $WORKON_HOME
#source /usr/local/bin/virtualenvwrapper_lazy.sh
#source /usr/local/bin/virtualenvwrapper.sh

# }}}


# Set locale
set -gx LC_ALL en_US.UTF-8
set -gx LANG en_US.UTF-8
