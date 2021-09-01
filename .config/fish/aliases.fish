# Quick edits
alias ea 'nvim ~/.config/fish/aliases.fish'
alias ef 'nvim ~/.config/fish/config.fish'
alias eg 'nvim ~/.gitconfig'
alias ev 'nvim ~/.config/nvim/init.vim'
alias evv 'vim ~/.vimrc'
alias es 'nvim ~/bin/autosort'
alias et 'nvim ~/.tmux.conf'

alias vim-norc 'vim -u NORC'
alias vim-none 'vim -u NONE'
alias nvim-norc 'nvim -u NORC'
alias nvim-none 'nvim -u NONE'

function pdftext
    pdftotext -layout $argv[1] -
end

function serve
    npx http-server --port 8000 $argv
end

function timestamp
    python -c 'import time; print(int(time.time()))'
end

set LS_COLORS dxfxcxdxbxegedabagacad

alias df 'df -m'
alias j jobs
alias l ls
alias ll 'ls -la'
alias ls 'ls -FG'
alias su 'su -m'

function lsd -d 'List only directories (in the current dir)'
    ls -d */ | sed -Ee 's,/+$,,'
end

# Colorized cat (will guess file type based on contents)
alias ccat 'pygmentize -g'

alias g git
alias c clear
alias vv 'command vim'
alias v nvim
alias vim nvim
alias x 'tig HEAD'
alias xx 'tig --exclude=production --exclude="*/production" --exclude=canary --exclude="*/canary" --branches'
alias xxa 'tig --exclude=production --exclude="*/production" --exclude=canary --exclude="*/canary" --all'
alias xxaa 'tig --all'
alias notes 'rg "TODO|HACK|FIXME|OPTIMIZE"'

alias m make
alias mm 'make run'

alias reset-mailbox 'rm -v ~/Library/Caches/com.dropbox.mbd.external-beta/mailbox.db'

function da -d "Allow or disallow .envrc after printing it."
    echo ------------------------------------------------
    cat .envrc
    echo ------------------------------------------------
    echo "To allow, hit Return."
    read answer
    direnv allow
end

function def -d "Quickly jump to place where a function, method, or variable is defined"
    va "^\s*(def\s+$argv|$argv\s*[=])"
end

function vimff
    nvim (ffind -tf $argv)
end

function f
    git ls-tree -r --name-only HEAD
end

alias drop-dependabot-branches "rm -rvf (git rev-parse --git-dir)/refs/remotes/origin/dependabot"

function vf
    f | fzf | xargs -o nvim
end

function val
    set pattern $argv[1]
    if test (count $argv) -gt 1
        set argv $argv[2..-1]
    else
        set argv
    end

    function to_safe
        sed -E -e 's/[\\][=]/__EQ__/g' -e 's/[\\][<]/__LT__/g' -e 's/[\\][>]/__GT__/g'
    end

    function to_unsafe_rg
        sed -E -e 's/__LT__/</g' -e 's/__GT__/>/g' -e 's/__EQ__/=/g'
    end

    function to_unsafe_vim
        sed -E -e 's/__LT__/[<]/g' -e 's/__GT__/[>]/g' -e 's/__EQ__/[=]/g'
    end

    set rg_pattern (echo $pattern | to_safe | sed -E -e 's/[<>]/\\\\b/g' | to_unsafe_rg)
    set vim_pattern (echo $pattern | to_safe | sed -E -e 's,([/=]),\\\\\1,g' -e 's,.*,/\\\\v&,' | to_unsafe_vim)
    rg -l --smart-case $rg_pattern -- $argv 2>/dev/null
end

function va
    set pattern $argv[1]
    if test (count $argv) -gt 1
        set argv $argv[2..-1]
    else
        set argv
    end

    function to_safe
        sed -E -e 's/[\\][=]/__EQ__/g' -e 's/[\\][<]/__LT__/g' -e 's/[\\][>]/__GT__/g'
    end

    function to_unsafe_rg
        sed -E -e 's/__LT__/</g' -e 's/__GT__/>/g' -e 's/__EQ__/=/g'
    end

    function to_unsafe_vim
        sed -E -e 's/__LT__/[<]/g' -e 's/__GT__/[>]/g' -e 's/__EQ__/[=]/g' -e 's/@/[@]/g'
    end

    set rg_pattern (echo $pattern | to_safe | sed -E -e 's/[<>]/\\\\b/g' | to_unsafe_rg)
    set vim_pattern (echo $pattern | to_safe | sed -E -e 's,([/=]),\\\\\1,g' -e 's,.*,/\\\\v&,' | to_unsafe_vim)
    rg -l --smart-case --null $rg_pattern -- $argv 2>/dev/null | xargs -0 -o nvim -c $vim_pattern
end

# "va", but case-sensitive (it's a copy of the above, but without the
# `--smart-case` argument in the final call)
function vacs
    set pattern $argv[1]
    if test (count $argv) -gt 1
        set argv $argv[2..-1]
    else
        set argv
    end

    function to_safe
        sed -E -e 's/[\\][=]/__EQ__/g' -e 's/[\\][<]/__LT__/g' -e 's/[\\][>]/__GT__/g'
    end

    function to_unsafe_rg
        sed -E -e 's/__LT__/</g' -e 's/__GT__/>/g' -e 's/__EQ__/=/g'
    end

    function to_unsafe_vim
        sed -E -e 's/__LT__/[<]/g' -e 's/__GT__/[>]/g' -e 's/__EQ__/[=]/g'
    end

    set rg_pattern (echo $pattern | to_safe | sed -E -e 's/[<>]/\\\\b/g' | to_unsafe_rg)
    set vim_pattern (echo $pattern | to_safe | sed -E -e 's,([/=]),\\\\\1,g' -e 's,.*,/\\\\v&,' | to_unsafe_vim)
    rg -l --null $rg_pattern -- $argv 2>/dev/null | xargs -0 -o nvim -c $vim_pattern
end

function vc
    if git modified -q $argv
        nvim (git modified $argv | sed -Ee 's/^"(.*)"$/\1/')
    else
        echo '(nothing changed)'
    end
end

function vca
    if git modified -qi
        nvim (git modified -i | sed -Ee 's/^"(.*)"$/\1/')
    else
        echo '(nothing changed)'
    end
end

function vci
    if git modified -qi
        nvim (begin; git modified -i; git modified; end | sort | uniq -u | sed -Ee 's/^"(.*)"$/\1/')
    else
        echo '(nothing changed)'
    end
end

alias vch 'vc head'
alias vch1 'vc head~1'
alias vch2 'vc head~2'
alias vch3 'vc head~3'
alias vch4 'vc head~4'

function vu
    if git modified -u $argv
        nvim (git modified -u $argv | sed -Ee 's/^"(.*)"$/\1/')
    else
        echo 'no files with conflicts'
    end
end

function vw
    nvim (which "$argv")
end

function vconflicts -d 'Opens all files with merge conflict markers in Vim'
    va '^(\<{7}|\>{7}|\={7})([ ].*)?$'
end

function fll -d 'Lists all files with Flow issues'
    flow | grep -Ee '^Error --' | rev | cut -d' ' -f1 | rev | cut -d: -f1 | sort -u
end

function veslint -d 'Opens all files in Vim with ESLint issues'
    eslint $argv | grep -Ee '^/' | xargs -o nvim
end

function vflow -d 'Opens all files with Flow issues in Vim'
    fll | xargs -o nvim
end

function vts -d 'Opens all files with TypeScript issues in Vim'
    tsc | grep -vEe '^\s' | cut -d'(' -f1 | sort -u | xargs -o nvim
end

# alias git hub
alias gti git
alias a 'git amend --allow-empty --no-verify'
alias gs 'git status -s'
alias gb 'git recent-branches 2.days.ago'
alias ggco 'git switchi'
alias ggbd 'git branch -D (g local-branches | fzf)'
alias fl 'clear; and flow-limit'
alias fflow 'flow stop; and flow'

function git-search
    git log -S"$argv" --pretty=format:%H | map git show
end

function cleanpycs
    find . -name '.git' -prune -o -name __pycache__ -delete
    find . -name '.git' -prune -o -name '*.py[co]' -delete
end

function cleanorigs
    find . '(' -name '*.orig' -o -name '*.BACKUP.*' -o -name '*.BASE.*' -o -name '*.LOCAL.*' -o -name '*.REMOTE.*' ')' -print0 | xargs -0 rm -f
end

function cleandsstores
    find . -name '.DS_Store' -exec rm -f '{}' ';'
end

alias json prettify-json
alias map 'xargs -n1'
alias collapse "sed -e 's/  */ /g'"
alias cuts 'cut -d\ '

function p -d "Start the best Python shell that is available"
    set -l cmd

    if test -f manage.py
        if pip freeze 2>/dev/null | grep -iq django-extensions
            set cmd (which python) manage.py shell_plus
        else
            if pip freeze 2>/dev/null | grep -iq flask-script
                # do nothing, use manage.py, fall through
                set -e cmd
            else
                set cmd (which python) manage.py shell
            end
        end
    end

    if test -z $cmd
        set -l interpreters (which bpython 2>/dev/null; which ipython 2>/dev/null; which python 2>/dev/null)

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
    printf "Using "
    set_color green
    echo $cmd
    set_color normal
    eval $cmd $argv
end

# alias pm 'python manage.py'
# alias pmm 'python manage.py migrate'
# alias pmmm 'python manage.py makemigrations'
# alias pms 'python manage.py shell_plus'
# alias pmr 'python manage.py runserver_plus 0.0.0.0:8000'

function pipr -d "Find & install all requirements for this project"
    pushd (git root)
    begin
        if test -f requirements.txt
            pip install -r requirements.txt
        end
        if test -f dev-requirements.txt
            pip install -r dev-requirements.txt
        end
        if test -f .pipignore
            pip install -r .pipignore
        end
    end
    popd
end

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

alias cd.. 'cd ..'
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
alias c-x 'chmod -x'

# }}}

function colorize-pboard
    if test (count $argv) -gt 0
        set lang $argv[1]
    else
        set lang python
    end
    pbpaste | strip-indents | color-syntax | pbcopy
end

function color-syntax
    if test (count $argv) -gt 0
        set lang $argv[1]
    else
        set lang python
    end
    pygmentize -f rtf -l $lang
end

alias h=heroku
alias gp='cd ~/Projects/SimpleContacts/core/api'
alias ga='cd ~/Projects/SimpleContacts/core/app_admin'
alias gbc='echo "Please use `gsh` instead!"'
alias gsh='cd ~/Projects/SimpleContacts/core/app_simplehealth'
alias cg='codegen'

function wtf -d "Print which and --version output for the given command"
    for arg in $argv
        echo $arg: (which $arg)
        echo $arg: (sh -c "$arg --version")
    end
end
