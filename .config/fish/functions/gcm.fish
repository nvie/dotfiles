function gcm --description "Draft a commit message with Haiku, then open editor"
    if git diff --staged --quiet
        echo "No staged changes." >&2
        return 1
    end

    if test -z "$ANTHROPIC_API_KEY"
        echo "ANTHROPIC_API_KEY not set." >&2
        return 1
    end

    set -l system_prompt "You write git commit messages in this exact style:
- Imperative mood, capitalized, no trailing period
- No Conventional Commit prefixes (no feat:, fix:, chore:, refactor:, etc.)
- Single-line subject most of the time; body ONLY when the 'why' isn't self-evident from the diff
- When you write a body: 1-3 short sentences of prose, no bullet lists, no file summaries, no 'this commit...' prefix
- Use a Unicode arrow surrounded by spaces for renames: 'Rename foo → bar'
- Subject under ~72 chars
- Dry wit and ™ are fine when they fit naturally; don't force them
- No AI trailers, no 'Generated with...', no Co-Authored-By

Output ONLY the commit message. No code fences, no preamble, no explanation."

    set -l tmpfile (mktemp)

    git diff --staged | jq -Rs --arg sys "$system_prompt" '{
        model: "claude-haiku-4-5-20251001",
        max_tokens: 400,
        system: $sys,
        messages: [{role: "user", content: ("Write a commit message for this staged diff:\n\n" + .)}]
    }' | curl -s https://api.anthropic.com/v1/messages \
        -H "x-api-key: $ANTHROPIC_API_KEY" \
        -H "anthropic-version: 2023-06-01" \
        -H "content-type: application/json" \
        -d @- | jq -r '.content[0].text // ""' >$tmpfile

    if not test -s $tmpfile
        echo "Failed to generate commit message." >&2
        rm $tmpfile
        return 1
    end

    git commit -e -F $tmpfile
    set -l rc $status
    rm $tmpfile
    return $rc
end
