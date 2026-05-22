function gcm --description "Draft a commit message with Sonnet, then open editor"
    if git diff --staged --quiet
        echo "No staged changes." >&2
        return 1
    end

    if test -z "$ANTHROPIC_API_KEY"
        echo "ANTHROPIC_API_KEY not set." >&2
        return 1
    end

    set -l context (string join " " $argv)

    set -l system_prompt "You write git commit messages for nvie.

OUTPUT FORMAT — STRICT:
- Plain text only. NO markdown, NO code fences, NO surrounding quotes.
- Output ONLY the commit message itself. No preamble, no 'Here is...', no trailing explanation.

STYLE — STRICT:
- Subject: imperative mood, capitalized, NO trailing period, under ~72 chars.
- NEVER use Conventional Commit prefixes. Forbidden: feat:, fix:, chore:, refactor:, docs:, test:, build:, ci:, perf:, style:. nvie really dislikes these.
- The subject must lead with the MOST INTERESTING change in the diff — the actual behavioral or architectural shift — NOT incidental cleanup like 'remove unused imports' or 'simplify logic'. Cleanup is a side-effect of the real change; name the real change.
- Single-line subject is the DEFAULT. Only write a body when the WHY is not self-evident from the diff itself.
- When a body is warranted: 1-3 short sentences of plain prose. NO bullet lists. NO file-by-file summaries. NO restating mechanical edits ('Remove unused X', 'Rename Y to Z'). NO 'this commit...' prefix.
- The diff documents WHAT changed. Your job is the WHY, and only when non-obvious. Most commits = subject only.
- Use a Unicode arrow with spaces for renames: Rename foo → bar
- Dry wit and ™ are fine when they fit naturally (e.g. 'The Big Inline™'); don't force.
- No AI trailers, no Co-Authored-By, no 'Generated with...'.

EXAMPLES of the target style (most have no body — that's the default):
Log full error details upon failing connection
Convert TS enums to objects + add new future AckOp type
Replace Jest by Vitest
Rename toolName → name everywhere
Fix a bug in LiveLists where two clients would not reach eventual consistency
Guarantee at-most-once execution for multi-tab tool calls
Add additionalProperties everywhere: it's required if you use OpenAI
SQLite refactoring: The Big Inline™"

    set -l respfile (mktemp)
    set -l msgfile (mktemp)

    echo "Generating commit message with Sonnet..." >&2
    git diff --staged | jq -Rs --arg sys "$system_prompt" --arg ctx "$context" '{
        model: "claude-sonnet-4-6",
        max_tokens: 400,
        system: $sys,
        messages: [{role: "user", content: (
            (if $ctx == "" then "" else "Extra context from the author (use this for the WHY in the body if it adds information not visible in the diff):\n" + $ctx + "\n\n" end)
            + "Write a commit message for this staged diff:\n\n" + .
        )}]
    }' | curl -s https://api.anthropic.com/v1/messages \
        -H "x-api-key: $ANTHROPIC_API_KEY" \
        -H "anthropic-version: 2023-06-01" \
        -H "content-type: application/json" \
        -d @- >$respfile

    jq -r '.content[0].text // ""' <$respfile >$msgfile

    if not test -s $msgfile
        echo "Failed to generate commit message. Raw API response:" >&2
        cat $respfile >&2
        echo >&2
        rm $respfile $msgfile
        return 1
    end

    git commit -e -F $msgfile
    set -l rc $status
    rm $respfile $msgfile
    return $rc
end
