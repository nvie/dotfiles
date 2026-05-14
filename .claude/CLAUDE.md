# General instructions

- When reporting information to me, be extremely concise and sacrifice grammar for the sake of concision.
- Don't overdo em-dashes in output I'm asking you to produce.
- Never guess or hallucinate. If you don't know something, tell me honestly, or ask me follow-up questions.
- I prefer fixing things the Correct™ way. By Correct™ I mean the non-hacky, strategic, long-term-focused way, not a quick tactical way that gets the issue at hand fixed ASAP. Sometimes this is still fine though, but always negotiate with me about it.
- Don't write code comments that reference past/previous/old implementations, prior bugs, or "the naive approach" -- comments describe the code as it is now. History belongs in commit messages, not source.
- When I ask you to explain, investigate, summarize, or "help me understand", answer the question first -- don't preemptively edit code unless I asked you to. If a fix becomes obvious during explanation, propose it and wait.
- Don't silently silence or suppress errors. If you must suppress (e.g. a noisy SDK warning), scope it as narrowly as possible (test/localhost only), and flag it to me -- never let production hide errors.

# Terminal power user

- I do all my work in a terminal (using Ghostty, Fish shell, and Neovim)
- I 'cd' into project directories and run commands locally, I rely on .envrc files (direnv) to set up my environments correctly
- I do not prefer GUIs like VS Code, or Cursor

# Local Turbo commands

I have some personal aliases:

- ni = Antfu's 'ni' tool that auto-uses the right package manager (npm, pnpm, or yarn) for this project
- tb = turbo run build
- td = turbo run dev
- tt = turbo run test
- ttd = turbo run test:types
- tte = turbo run test:e2e
- tth = turbo run test:headed
- Never commit your work to Git autonomously. Only do so when I ask.

# Working with Git

CRITICAL - NEVER VIOLATE THESE RULES:

- NEVER `git push` - unless I explicitly ask you
- NEVER `git commit --amend` - always create a new commit
- NEVER `git rebase`, `git reset --hard`, or any history-rewriting command
- Only commit or amend when explicitly asked
- If a fix is needed after a commit, create a NEW commit
- NEVER try to "fix" git state - I'm a Git power user
- Detached HEAD, ongoing rebases, etc. are always intentional
- Don't run `git rebase --continue/--abort` or similar commands

## My git vocabulary

- "delouse" = my `git delouse` (from nvie/git-toolbelt): soft-reset HEAD and re-commit as empty with the original commit's message. Result: commit message preserved, the original changes return to the working tree unstaged so I can re-select what to keep. If I say "I deloused your commit", the file changes you made are now unstaged and may be partially discarded.

# General workflow

- Never start dev servers yourself -- I run them manually
- When committing multiple changes, commit each atomic change separately
- Reuse existing components/utilities -- never duplicate or reinvent

# Code quality

- Never use `as` casts blindly -- explain the type issue and let me decide. If it would interrupt flow, leave an `// XXX` comment above it instead.
- Mark any temporary, throwaway, or revisit-later code with `// XXX` comments -- most projects have a lint rule that fails CI on XXX, so nothing slips through.
- Split type-only imports from value imports: prefer `import type { Bar, Qux } from "xyz"; import { foo, baz } from "xyz"` over inline `import { foo, type Bar, type Qux, baz } from "xyz"`.

# Writing commit messages

Most commits are just a **single-line subject, no body**. A body is only added when the _why_ isn't self-evident, and even then it's 1-2 short paragraphs of prose explaining the reasoning or context. Match that style.

Do NOT pad the body with enumerations of changed files, moved symbols, renamed methods, or bullet-lists of mechanical edits -- the diff already shows that. The only exception is when the mechanical listing **is** the point of the commit (e.g. a pure file rename, a batch rename across the codebase), in which case the list _is_ the explanation.

- Imperative, capitalized, no trailing period
- No Conventional Commit prefixes (no `feat:`, `fix:`, `chore:`, etc.) – I really dislike these!
- Use a Unicode arrow surrounded by spaces for renames: 'Rename `foo` → `bar`'
- Don't append `(#1234)` — GitHub does that on squash-merge
- Only write a body when the _why_ isn't obvious from the diff. When you do, 1-3 short sentences, no bullet lists, no file summaries, no "this commit..." prefix
- Never add AI trailers ("Generated with Claude Code", "Co-Authored-By: Claude")
- Dry wit / `™` is fine when it fits ("The Big Inline™"); don't force it

Representative examples of my style:

- 'Log full error details upon failing connection'
- 'Convert TS enums to objects + add new future AckOp type'
- 'Replace Jest by Vitest'
- 'Rename `toolName` → `name` everywhere'
- 'Fix a bug in LiveLists where two clients would not reach eventual consistency'
- 'Guarantee at-most-once execution for multi-tab tool calls'
- 'Add `additionalProperties` everywhere: it's required if you use OpenAI'
- 'SQLite refactoring: The Big Inline™'
