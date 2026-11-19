# Show a message as big as the terminal allows, until `q` or ctrl+c is pressed.
# Renders the text to a transparent PNG with ImageMagick, then draws it
# full-screen with chafa (sharp pixels via the kitty graphics protocol)
# on the alternate screen, so the scrollback is left untouched. Redraws
# when the terminal is resized.
# Usage: big "BRB"
function big
    tput smcup
    tput civis
    set -l old (stty -g)
    # Reads time out after 1s, so the loop can notice resizes. -isig makes
    # ctrl+c arrive as a plain keypress, so it quits cleanly like `q`
    stty -echo -icanon -isig min 0 time 10
    set -l drawn
    while true
        set -l size (stty size)
        if test "$size" != "$drawn"
            __big_draw $size $argv
            set drawn $size
        end
        set -l key (dd bs=1 count=1 2>/dev/null)
        contains -- "$key" q \cc; and break
    end
    stty $old
    tput cnorm
    tput rmcup
end

function __big_draw
    set -l parts (string split ' ' -- $argv[1])
    set -l rows $parts[1]
    set -l cols $parts[2]
    # Delete earlier kitty-protocol images, then clear the text
    printf '\e_Ga=d\e\\'
    clear
    # C=1 (kitty protocol) keeps the cursor from moving below the image,
    # so it can fill the full height without scrolling
    magick -background none -fill white \
        -font /Library/Fonts/SF-Pro-Rounded-Heavy.otf -gravity center \
        -size (math $cols x 20)x(math $rows x 40) caption:"$argv[2..]" png:- \
        | chafa --stretch --size {$cols}x{$rows} - \
        | string replace '_Ga=T,' '_Ga=T,C=1,'
    # chafa re-shows the cursor when done
    tput civis
end
