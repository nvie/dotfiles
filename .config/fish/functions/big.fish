# Show a message as big as the terminal allows, until `q` is pressed.
# Renders the text to a transparent PNG with ImageMagick, then draws it
# full-screen with chafa (sharp pixels via the kitty graphics protocol)
# on the alternate screen, so the scrollback is left untouched. Redraws
# when the terminal is resized.
# Usage: big "BRB"
function big
    tput smcup
    tput civis
    set -l old (stty -g)
    # Reads time out after 1s, so the loop can notice resizes
    stty -echo -icanon min 0 time 10
    set -l drawn
    while true
        set -l size (stty size)
        if test "$size" != "$drawn"
            __big_draw $size $argv
            set drawn $size
        end
        string match -q q -- (dd bs=1 count=1 2>/dev/null); and break
    end
    stty $old
    tput cnorm
    tput rmcup
end

function __big_draw
    set -l parts (string split ' ' -- $argv[1])
    set -l rows (math $parts[1] - 1)
    set -l cols $parts[2]
    # Delete earlier kitty-protocol images, then clear the text
    printf '\e_Ga=d\e\\'
    clear
    magick -background none -fill white \
        -font /Library/Fonts/SF-Pro-Rounded-Heavy.otf -gravity center \
        -size (math $cols x 20)x(math $rows x 40) caption:"$argv[2..]" png:- \
        | chafa --stretch --size {$cols}x{$rows} -
end
