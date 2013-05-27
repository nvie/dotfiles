function abspath -d 'Calculates the absolute path for the given path'
    set -l cwd ''
    pushd $argv[1]; and set cwd (pwd); and popd
    echo $cwd
end
