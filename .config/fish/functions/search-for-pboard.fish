function search-for-pboard
    commandline -- 'va \''(
        pbpaste \
        | head -n1 \
        | sed -E \
              -e 's/^[[:space:]]*//' \
              -e 's/[[:space:]]*$//' \
              -e "s/[.]/__DOT__/g" \
              -e "s/[]['\"\\`()*{}+^\$?|<>&]/./g" \
              -e "s/__DOT__/\[.\]/g" \
        )'\''
end
