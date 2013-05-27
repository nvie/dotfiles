# Quick edits
alias ea 'vim ~/.config/fish/aliases.fish'
alias ef 'vim ~/.config/fish/config.fish'
alias eg 'vim ~/.gitconfig'
alias ev 'vim ~/.vimrc'
alias et 'vim ~/.tmux.conf'

function serve
	if test (count $argv) -ge 1
	    /bin/sh -c "(cd $argv[1] && python -m SimpleHTTPServer)"
	else
	    python -m SimpleHTTPServer
	end
end

set LS_COLORS dxfxcxdxbxegedabagacad

alias ty 'tmux-open yes'
alias ls 'command ls -FG'
alias l ls
alias ll 'ls -la'
alias g git
alias c clear
alias v vim
alias a 'ack --smart-case'
function ack -d "ack supporting local .ackrc files"
    set ackrc
    if test -f ./.ackrc
        set ackrc (grep -ve '^#' | awk '/.+/ { print }' < ./.ackrc)
    end
    command ack $ackrc $argv
end

function def -d "Quickly finds where a function is defined."
    a -l "def\s+$argv"
end

function vimff
	vim (ffind -tf $argv)
end
function f
    ffind -tf | grep -v "/migrations/" | fuzzymatch.py $argv
end
function fa
    ffind -tf | fuzzymatch.py $argv
end
function vimf
    #vim (f $argv)
    cowsay "Try to learn to use 'vf', man."
end
function vf
    vim (f $argv)
end
function vfa
    vim (fa $argv)
end
function va
    ack -l --smart-case -- "$argv" ^/dev/null | xargs -o vim -c "/$argv"
end
function vaa
    ack -la --smart-case -- "$argv" ^/dev/null | xargs -o vim -c "/$argv"
end
alias git hub
alias gti git
alias su 'command su -m'
alias df 'command df -m'
alias vg vagrant

alias ggpush 'git push origin (git_current_branch)'
function git-search
    git log -S"$argv" --pretty=format:%H | map git show 
end

alias top 'glances'
function cleanpycs
	find . -name '*.py[co]' -exec rm '{}' ';'
end
function cleanorigs
    find . '(' -name '*.orig' -o -name '*.BACKUP.*' -o -name '*.BASE.*' -o -name '*.LOCAL.*' -o -name '*.REMOTE.*' ')' -print0 | xargs -0 rm -f
end
alias json 'prettify-json'
alias shiftr "sed -Ee 's/^/    /'"
alias shiftl "sed -Ee 's/^([ ]{4}|[\t])//'"
alias map 'xargs -n1'
alias collapse "sed -e 's/  */ /g'"
alias cuts 'cut -d\ '

function pgr -d "Grep for a running process, returning its PID and full string"
    ps auxww | grep --color=always $argv | grep -v grep | collapse | cuts -f 2,11-
end

function p -d "Start the best Python shell that is available"
    set -l cmd

    if test -f manage.py
        if pip freeze ^/dev/null | grep -q 'django-extensions'
            set cmd (which python) manage.py shell_plus
        else
            set cmd (which python) manage.py shell
        end
    else
        set -l interpreters (which ipython ^/dev/null; which python ^/dev/null)

        if test -z "$interpreters"
            set_color red
            echo "No python interpreters found on the PATH."
            set_color normal
            return 127
        end

        # Try to find the first interpreter within the current virtualenv
        # Rationale: it's more important to start a Python interpreter in the
        # current virtualenv than it is to start an _IPython_ interpreter (for
        # example, when the current virtualenv has no ipython installed, but such
        # would be installed system-wide).
        for interp in $interpreters
            #echo '-' $interp
            #echo '-' (dirname (dirname $interp))
            if test (dirname (dirname $interp)) = "$VIRTUAL_ENV"
                set cmd $interp
                break
            end
        end

        # If they all fall outside the virtualenv, pick the first match
        # (preferring ipython over python)
        if test -z "$cmd"
            set cmd $interpreters[1]
        end
    end

    # Run the command
    printf "Using "; set_color green; echo $cmd; set_color normal
    eval $cmd
end

alias pm 'python manage.py'
alias pmt 'python manage.py test'

# Projects
alias y 'deactivate ^&1 >/dev/null; cd ~/Projects/yes'

# Directories {{{

function cdff --description "cd's into the current front-most open Finder window's directory"
    cd (ff $argv)
end

function ff
    echo '
    tell application "Finder"
        if (1 <= (count Finder windows)) then
            get POSIX path of (target of window 1 as alias)
        else
            get POSIX path of (desktop as alias)
        end if
    end tell
    ' | osascript -
end

alias .. 'cd ..'
alias ... 'cd ../..'
alias .... 'cd ../../..'
alias ..... 'cd ../../../..'

alias md 'mkdir -p'
function take
    set -l dir $argv[1]
    mkdir -p $dir; and cd $dir
end
alias cx 'chmod +x'
alias 'c-x' 'chmod -x'

alias l1 'tree --dirsfirst -ChFL 1'
alias l2 'tree --dirsfirst -ChFL 2'
alias l3 'tree --dirsfirst -ChFL 3'
alias l4 'tree --dirsfirst -ChFL 4'
alias l5 'tree --dirsfirst -ChFL 5'
alias l6 'tree --dirsfirst -ChFL 6'

alias ll1 'tree --dirsfirst -ChFupDaL 1'
alias ll2 'tree --dirsfirst -ChFupDaL 2'
alias ll3 'tree --dirsfirst -ChFupDaL 3'
alias ll4 'tree --dirsfirst -ChFupDaL 4'
alias ll5 'tree --dirsfirst -ChFupDaL 5'
alias ll6 'tree --dirsfirst -ChFupDaL 6'

#alias l l1
#alias ll ll1

# }}}

function colorize-pboard
    if test (count $argv) -gt 0
        set lang $argv[1]
    else
        set lang 'python'
    end
    pbpaste | strip-indents | color-syntax | pbcopy
end

function color-syntax
    if test (count $argv) -gt 0
        set lang $argv[1]
    else
        set lang 'python'
    end
    pygmentize -f rtf -l $lang
end
