# mostly from http://coderseye.com/2010/using-virtualenv-with-fish-shell.html

function workon -d "Activate virtual environment in $WORKON_HOME"
  set tgt {$WORKON_HOME}/$argv[1]

  if [ -d $tgt ]
    deactivate

    set -gx VIRTUAL_ENV "$tgt"
    set -gx _OLD_VIRTUAL_PATH $PATH
    set -gx PATH "$VIRTUAL_ENV/bin" $PATH

    # unset PYTHONHOME if set
    if set -q PYTHONHOME
       set -gx _OLD_VIRTUAL_PYTHONHOME $PYTHONHOME
       set -e PYTHONHOME
    end

    set_color normal
    printf 'Virtualenv '
    set_color green
    printf $argv[1]
    set_color normal
    echo ' activated'
  else
    echo "$tgt not found"
  end
end

complete -c workon -fa "(cd $WORKON_HOME; find * -type d -maxdepth 0)"

function deactivate -d "Exit virtualenv and return to normal shell environment"
    # reset old environment variables
    if test -n "$_OLD_VIRTUAL_PATH"
        set -gx PATH $_OLD_VIRTUAL_PATH
        set -e _OLD_VIRTUAL_PATH
    end
    if test -n "$_OLD_VIRTUAL_PYTHONHOME"
        set -gx PYTHONHOME $_OLD_VIRTUAL_PYTHONHOME
        set -e _OLD_VIRTUAL_PYTHONHOME
    end
    set -e VIRTUAL_ENV
end


function use_env -d "Switch to virtualenv if not already there"
    if test (count $argv) -ne 1
        echo "error: Please provide an argument to use_env." >&2
        return 2
    end

    set -l venv $argv[1]
    if test (basename "$VIRTUAL_ENV") != "$venv"
        if find $WORKON_HOME/* -type d -maxdepth 0 | xargs -n1 basename | grep -q "$venv"
            workon "$venv"
        else
            read -p 'echo "Create virtualenv \"$venv\" now? (Yn) "' answer
            if test "$answer" = "y" -o "$answer" = ""
                mkvirtualenv --distribute "$venv"
            end
        end
    end
    return 0
end
