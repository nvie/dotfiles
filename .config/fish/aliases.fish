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

alias ls 'command ls -FG'
alias l ls
alias ll 'ls -la'
alias g git
alias c clear
alias v vim

alias a 'ag --smart-case'

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
    f $argv | selecta | xargs -o vim
end
function vfa
    fa $argv | selecta | xargs -o vim
end
function va
    ag -l --smart-case -- "$argv" ^/dev/null | quote | xargs -o vim -c "/$argv"
end
function vaa
    ag -la --smart-case -- "$argv" ^/dev/null | quote | xargs -o vim -c "/$argv"
end
function vc
    if git modified -q $argv
        vim (git modified $argv | sed -Ee 's/^"(.*)"$/\1/')
    else
        echo '(nothing changed)'
    end
end
function vca
    if git modified -qi
        vim (git modified -i | sed -Ee 's/^"(.*)"$/\1/')
    else
        echo '(nothing changed)'
    end
end
function vu
    if git modified -u $argv
        vim (git modified -u $argv | sed -Ee 's/^"(.*)"$/\1/')
    else
        echo 'no files with conflicts'
    end
end
function vw
    vim (which "$argv")
end
function vt
    vim -c "autocmd VimEnter * tag $argv" \
        -c "autocmd VimEnter * set syntax" \
        -c "autocmd VimEnter * normal zz" \
        -c "autocmd VimEnter * normal 6<C-e>"
end
alias git hub
alias gti git
alias su 'command su -m'
alias df 'command df -m'
alias vg vagrant

alias ggco 'git recent-branches | selecta | xargs git checkout'
function git-search
    git log -S"$argv" --pretty=format:%H | map git show 
end

alias top 'glances'
function cleanpycs
	find . -name '*.py[co]' -exec rm -f '{}' ';'
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
    eval $cmd $argv
end

alias pm 'python manage.py'
alias pms 'python manage.py shell_plus'
alias pmt 'python manage.py test'

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

# Projects
alias ty 'tmux-open yes'
alias y 'deactivate ^&1 >/dev/null; cd ~/Projects/yes'
alias yj 'deactivate ^&1 >/dev/null; cd ~/Projects/yes/yes/static/js'
alias yl 'deactivate ^&1 >/dev/null; cd ~/Projects/yes/yes/static/less'
alias ya 'deactivate ^&1 >/dev/null; cd ~/Projects/yes/yes/apps'
function prpm; production run "python manage.py $argv"; end
function srpm; staging run "python manage.py $argv"; end
function frpm; fuckyeah run "python manage.py $argv"; end
function prpms; prpm shell; end
function srpms; srpm shell; end
function frpms; frpm shell; end
alias prb 'production run bash'
alias srb 'staging run bash'
alias frb 'fuckyeah run bash'
