function abspath -d 'Calculates the absolute path for the given path'
    set -l cwd ''
    set -l curr (pwd)
    cd $argv[1]; and set cwd (pwd); and cd $curr
    echo $cwd
end
