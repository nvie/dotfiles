# Show a message as big as the terminal allows, until `q` is pressed.
# Renders the text to a transparent PNG with ImageMagick, then draws it
# full-screen with chafa (sharp pixels via the kitty graphics protocol)
# on the alternate screen, so the scrollback is left untouched.
# Usage: big "BRB"
function big
    set -l rows (math $LINES - 1)
    tput smcup
    clear
    magick -background none -fill white \
        -font /Library/Fonts/SF-Pro-Display-Bold.otf -gravity center \
        -size (math $COLUMNS x 20)x(math $rows x 40) caption:"$argv" png:- \
        | chafa --stretch --size {$COLUMNS}x{$rows} -
    tput civis
    set -l old (stty -g)
    stty -echo -icanon
    while not string match -q q -- (dd bs=1 count=1 2>/dev/null)
    end
    stty $old
    tput cnorm
    tput rmcup
end
