function prepend-to-path --description 'Adds the given directory to the front of the PATH'
    set -l dir ''
    if test (count $argv) -ne 0
        set dir $argv[1]
    end

    if test -d $dir
        set dir (abspath $dir)

        # If this path is already in the PATH array, remove all occurrences
        # and add it to the head
        for i in (seq (count $PATH) 1)
            if test $PATH[$i] = $dir
                set -e PATH[$i]
            end
        end
        set PATH $dir $PATH
    else
        echo "Dir $dir does not exist?"
    end
end
