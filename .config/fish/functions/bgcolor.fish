function bgcolor --description 'Set terminal background color via OSC 11'
    set -l colors \
        "#1a0d2e purple" \
        "#0d1a2e blue" \
        "#0d1f0d green" \
        "#1f1a0d brown" \
        "#2e0d1a plum" \
        "#1f1f0d olive" \
        "#2e1f0d amber" \
        "#0d2e1a teal"

    if test (count $argv) -eq 0
        if not command -q fzf
            echo "fzf not found" >&2
            return 1
        end

        set -l items
        for c in $colors
            set -l hex (string split ' ' $c)[1]
            set -a items (printf '11;%s\t%s' $hex $c)
        end
        set -a items (printf '111\treset')

        set -l picked (printf '%s\n' $items | fzf \
            --delimiter \t --with-nth 2.. \
            --prompt 'bg> ' --height '~40%' \
            --with-shell 'sh -c' \
            --bind "focus:execute-silent(printf '\\e]%s\\e\\\\' {1} > /dev/tty)")

        test -z "$picked"; and return 0
        printf '\e]%s\e\\' (string split \t $picked)[1] > /dev/tty
        return
    end

    if string match -qr '^#[0-9a-fA-F]{6}$' -- $argv[1]
        printf '\e]11;%s\e\\' $argv[1] > /dev/tty
        return
    end

    if test "$argv[1]" = reset
        printf '\e]111\e\\' > /dev/tty
        return
    end

    for entry in $colors
        set -l parts (string split ' ' $entry)
        if test "$parts[2]" = "$argv[1]"
            printf '\e]11;%s\e\\' $parts[1] > /dev/tty
            return
        end
    end

    set -l names
    for c in $colors
        set -a names (string split ' ' $c)[2]
    end
    echo "usage: bgcolor [$(string join '|' $names reset)]" >&2
    return 1
end
