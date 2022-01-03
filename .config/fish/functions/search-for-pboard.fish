function search-for-pboard
    # Never paste if there are more than 2 lines
    if test (pbpaste | wc -l) -lt 2
        commandline -- 'va \''(
		    pbpaste \
		    | sed -E \
		          -e 's/^[[:space:]]*//' \
		          -e 's/[[:space:]]*$//' \
		          -e "s/[.]/__DOT__/g" \
		          -e "s/[]['\"`()*{}+^\$?|<>]/./g" \
		          -e "s/__DOT__/\[.\]/g" \
		)'\''
    end
end
