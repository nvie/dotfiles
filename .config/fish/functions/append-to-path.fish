function append-to-path -d 'Adds the given directory to the end of the PATH'
    set -l dir '.'
    if test (count $argv) -ne 0
        set dir $argv[1]
    end

    set dir (abspath $dir)
    if test -n $dir; and test -d $dir
        if not contains $dir $PATH
            set PATH $PATH $dir
        end
    end
end
