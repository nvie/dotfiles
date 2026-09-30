function title --description 'Set a fixed terminal/tab title (no args = restore default)'
    functions -q __default_fish_title
    or functions -c fish_title __default_fish_title

    functions -e fish_title
    if test (count $argv) -eq 0
        functions -c __default_fish_title fish_title
    else
        set -g __title $argv
        function fish_title
            echo $__title
        end
    end
end
