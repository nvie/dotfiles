# Quick edits
alias ea 'nvim ~/.config/fish/aliases.fish'
alias ef 'nvim ~/.config/fish/config.fish'
alias eg 'nvim ~/.gitconfig'
alias egg 'nvim ~/.config/ghostty/config'
alias ev 'nvim ~/.config/nvim/init.vim'
alias evv 'vim ~/.vimrc'
alias es 'nvim ~/bin/autosort'

alias zz 'open -a Zed .'

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
# alias ll 'ls -la'
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
alias xx 'tig --exclude=production --exclude="*/production" --exclude=canary --exclude="*/canary" --exclude="*/dependabot/*" --branches'
alias xxa 'tig --exclude=production --exclude="*/production" --exclude=canary --exclude="*/canary" --exclude="*/dependabot/*" --all'
alias xxaa 'tig --all'
alias notes 'rg --hidden --glob=!.git/ "TODO|HACK|FIXME|OPTIMIZE"'

# Common typos I make
alias gaa 'git aa'
alias gst 'git st'
alias gpr 'git pr'

alias m make
alias mm 'make run'

alias xxx 'sr -s "\b(XXX|YYY)(_vincent)?\b"'
alias xxxx 'sr -s "\b(XXX)(_vincent)?\b"'
alias vx 'rg --hidden --glob=!.git/ -l --null "\b(XXX|YYY)(_vincent)?\b" -- 2>/dev/null | xargs -0 -o nvim -c "/\v<(XXX|YYY)(_vincent)?>"'
alias vxx 'rg --hidden --glob=!.git/ -l "\b(XXX(_vincent)?)\b" -- 2>/dev/null | grep -vFEe .git/ | xargs -o nvim -c "/\v<(XXX(_vincent)?)>"'

alias reset-mailbox 'rm -v ~/Library/Caches/com.dropbox.mbd.external-beta/mailbox.db'

function ccc -d 'Run claude in high permission mode'
    cd (git root) && claude --dangerously-skip-permissions $argv
end

function brew-outdated-leaves -d "List outdated packages, but only _leaf_ packages"
    combine (brew outdated | cut -d'(' -f1 | cut -d'@' -f1 | psub) and (brew leaves | psub) | xargs brew outdated
end

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
    edit ( f | fzf )
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
    rg --hidden --glob=!.git/ -l --smart-case $rg_pattern -- $argv 2>/dev/null
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
    set vim_pattern (echo $pattern | to_safe | sed -E -e 's,([/=~]),\\\\\1,g' -e 's,.*,/\\\\v&,' | to_unsafe_vim)
    rg --hidden --glob=!.git/ -l --smart-case --null $rg_pattern -- $argv 2>/dev/null | xargs -0 -o nvim -c $vim_pattern
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
    rg --hidden --glob=!.git/ -l --null $rg_pattern -- $argv 2>/dev/null | xargs -0 -o nvim -c $vim_pattern
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

# Open all files from the last commit that changes any files in the current directory
alias vch 'vc (git log -1 --pretty=%H .)'

# Run test and open the first failing test in Vim, jumping straight to the assertion that failed
alias vt 'vitest --bail 1 --run --no-color 2>&1 | grep -oEe \'❯ test.*:[[:digit:]]+\' | head -n1 | cut -d" " -f2 | cut -d: -f1,2 | rev | sed -Ee "s/:/\+ /" | rev | xargs -o nvim'

# Open all files from the nth-last commit
alias vch0 'vc HEAD'
alias vch1 'vc HEAD~1'
alias vch2 'vc HEAD~2'
alias vch3 'vc HEAD~3'
alias vch4 'vc HEAD~4'

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
    flow --show-all-errors --json | jq -r '.errors[].message[].path' | sort -u | map realpath --relative-to=.
end

#
# The following helper can be invoked like so:
#
#     $ edit ( produce | grep -Ee foo )
#            ^^^^^^^^^^^^^^^^^^^^^^^^^^
#            Any Unix command producing a list of file
#            paths on stdout.
#
# This is to replace usage of the following structure:
#
#     $ produce | grep -Ee foo | xargs -o $EDITOR
#
# Which unfortunately suffers from an annoying bug in Fish related to how
# Ctrl+Z and `fg` then work. See also the bug report:
# https://github.com/fish-shell/fish-shell/issues/8263
#
function edit -d 'Opens $EDITOR with the files given, but is a no-op if the list is empty'
    if test ( count $argv ) -gt 0
        $EDITOR $argv
    end
end

function veslint -d 'Opens all files in Vim with ESLint issues'
    if test ./turbo.json
        edit ( npx turbo run --log-prefix=none lint | grep -Ee '^/' )
    else
        edit ( eslint $argv | grep -Ee '^/' )
    end
end

function vjest -d 'Opens the first failing test case in Vim and jumps to the failing line'
    edit ( jest $argv --bail --silent 2>&1 | grep -oEe '^\s+at .*\(([^:]+):(\d+)' | grep -vEe '(node_modules|dist|lib)/' | cut -d'(' -f2 | head -n1 | sed -Ee "s/:/\n+/" )
end

function tsf -d 'Lists all files with TypeScript issues'
    tsc $argv | grep -vEe '^\s' | cut -d: -f1 | rev | cut -d'(' -f2- | rev | sort -u
end

function vts -d 'Opens all files with TypeScript issues in Vim'
    if test "$argv[1]" = --incremental
        echo "No longer needed to specify --incremental here 😇" >&2
    else
        edit ( tsf --incremental $argv )
    end
end

# alias git hub
alias gti git
alias a 'git amend --allow-empty --no-verify'
alias gs 'git status -s'
alias gb 'git recent-branches 2.days.ago'
alias ggco 'git iswitch'
alias ggbd 'git branch -D (git local-branches | grep -vxEe "$(git current-branch)" | fzf)'
alias fl 'clear; and flow-limit'
alias fflow 'flow stop; and flow'
alias tll "tsc | grep -Ee 'TS\d+' | cut -d'(' -f1 | sort -u"

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
alias cd... 'cd ../..'
alias .. 'cd ..'
alias ... 'cd ../..'
#alias .... 'cd ../../..'
#alias ..... 'cd ../../../..'

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

alias gp='cd ~/Projects/liveblocks/liveblocks'
alias ga='cd ~/Projects/liveblocks/liveblocks.io'
alias cdio='cd ~/Projects/liveblocks/liveblocks.io'
alias cdcc='cd ~/Projects/liveblocks/liveblocks/packages/liveblocks-core'
alias cdc='cd ~/Projects/liveblocks/liveblocks/packages/liveblocks-client'
alias cdr='cd ~/Projects/liveblocks/liveblocks/packages/liveblocks-react'
alias cde='cd ~/Projects/liveblocks/liveblocks/packages/liveblocks-emails'
alias cdru='cd ~/Projects/liveblocks/liveblocks/packages/liveblocks-react-ui'
alias cdrc=cdru
alias cdrr='cd ~/Projects/liveblocks/liveblocks/packages/liveblocks-redux'
alias cdrl='cd ~/Projects/liveblocks/liveblocks/packages/liveblocks-react-lexical'
alias cdrb='cd ~/Projects/liveblocks/liveblocks/packages/liveblocks-react-blocknote'
alias cdrt='cd ~/Projects/liveblocks/liveblocks/packages/liveblocks-react-tiptap'
alias cdnl='cd ~/Projects/liveblocks/liveblocks/packages/liveblocks-node-lexical'
alias cdy='cd ~/Projects/liveblocks/liveblocks/packages/liveblocks-yjs'
alias cdz='cd ~/Projects/liveblocks/liveblocks/packages/liveblocks-zustand'
alias cdzz='cd ~/Projects/liveblocks/liveblocks-backend/shared/zenrouter'
alias cdn='cd ~/Projects/liveblocks/liveblocks/packages/liveblocks-node'
alias cdd='cd ~/Projects/liveblocks/liveblocks-backend/tools/liveblocks-cli'
alias cda='cd ~/Projects/liveblocks/admin'
alias cdf='cd ~/Projects/liveblocks/liveblocks-backend/apps/cloudflare'
alias cdbb='cd ~/Projects/liveblocks/liveblocks-backend'
alias cdbj='cd ~/Projects/liveblocks/liveblocks-backend/apps/aws-jobs'
alias cdbr='cd ~/Projects/liveblocks/liveblocks-backend/apps/lambda-rest-api'
alias cdbm='cd ~/Projects/liveblocks/liveblocks-backend/tools/mongodb-migration'
alias cdb='cd ~/Projects/liveblocks/liveblocks-backend/apps/bun-server'
alias cds='cd ~/Projects/liveblocks/liveblocks-backend/shared/liveblocks-server'
alias cdsc='cd ~/Projects/liveblocks/liveblocks/schema-lang/liveblocks-schema'
alias cdi='cd ~/Projects/liveblocks/liveblocks/schema-lang/infer-schema'
alias cdq='cd ~/Projects/liveblocks/liveblocks-backend/shared/liveblocks-query-parser'
alias cdR=cdbr
alias cddocs='cd ~/Projects/liveblocks/liveblocks/docs'
alias cdsink='cd ~/Projects/liveblocks/liveblocks/e2e/next-ai-kitchen-sink'
alias liveblocks-dependencies="jq -r '((.dependencies,.peerDependencies,.devDependencies) // []) | keys[]' package.json | sort -u | grep --color=never -Ee @liveblocks/"

function liveblocks
    sh -c 'output=$(cd ~/Projects/liveblocks/liveblocks-backend/tools/liveblocks-cli && npx turbo run build 2>&1) && { echo "$output" | grep -q "FULL TURBO" || echo "$output"; } && node ~/Projects/liveblocks/liveblocks-backend/tools/liveblocks-cli/dist/index.js "$@"' -- $argv
end

function wtf -d "Print which and --version output for the given command"
    for arg in $argv
        echo $arg: (which $arg)
        echo $arg: (sh -c "$arg --version")
    end
end

function turbo_or_npm
    if which -s turbo
        turbo $argv
    else
        npm run $argv
    end
end

function turboshhhh_or_npm
    if which -s turbo
        turbo --log-prefix none $argv
    else
        npm run $argv
    end
end

alias tb 'turbo_or_npm build'
alias tbd 'turbo_or_npm build:deps'
alias tbf 'turbo_or_npm build:firefox'
alias tt 'turbo_or_npm test'
alias tq 'kill-port 37897; kill-port 37898; killall workerd; scripts/run-unit-tests-locally.sh test/plugins test/storage test/yjs test/websockets test/api/v2/rooms/\{roomId\}/storage.test.ts'
alias tqq 'kill-port 37897; kill-port 37898; killall workerd; scripts/run-unit-tests-locally.sh test/plugins'
alias tfq 'kill-port 37897; kill-port 37898; killall workerd; scripts/run-unit-tests-locally.sh'
alias td 'turbo_or_npm dev'
alias ttt 'turbo_or_npm test:types'
alias ttd 'turbo_or_npm test:deps'
alias tth 'turbo_or_npm test:headed'
alias ttu 'turbo_or_npm test:ui'
alias tte 'turbo_or_npm test:e2e'
alias ttw 'turbo_or_npm test:watch'
alias tl 'turboshhhh_or_npm lint'
alias tlp 'turbo_or_npm lint:package'
alias tf 'turbo_or_npm format'
alias tp 'turbo_or_npm package'
alias ncu 'npx npm-check-updates --interactive'
alias ncuw 'npx npm-check-updates --interactive --root --workspaces'

# Quick bisecting
alias gbr 'git bisect reset'
alias gbs 'cd (git root) && git bisect start (git current-branch) (git merge-base (git current-branch) main)'
alias good 'git bisect good'
alias bad 'git bisect bad'
