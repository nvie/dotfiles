# Show a message as big as the terminal allows, until `q` or ctrl+c is pressed.
# Renders the text to a transparent PNG with ImageMagick, then draws it
# full-screen via the kitty graphics protocol on the alternate screen, so the scrollback is left untouched. Redraws
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
    set -l chunks (
        magick -background none -fill white \
            -font /Library/Fonts/SF-Pro-Rounded-Heavy.otf -gravity center \
            -size (math $cols x 20)x(math $rows x 40) caption:"$argv[2..]" png:- \
            | base64 | fold -w 4096
    )
    # Send the PNG as is (f=100), stretched over all cells (c, r), in chunks
    # of at most 4096 bytes (m=1 means more follow). C=1 keeps the cursor
    # from moving below the image, so it can fill the full height without
    # scrolling. q=2 silences the terminal's replies.
    set -l n (count $chunks)
    for i in (seq $n)
        set -l more 1
        test $i -eq $n; and set more 0
        if test $i -eq 1
            printf '\e_Ga=T,f=100,C=1,c=%d,r=%d,q=2,m=%d;%s\e\\' $cols $rows $more $chunks[$i]
        else
            printf '\e_Gm=%d;%s\e\\' $more $chunks[$i]
        end
    end
end
