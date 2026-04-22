# General instructions

- When reporting information to me, be extremely concise and sacrifice grammar for the sake of concision.
- Don't overdo em-dashes in output I'm asking you to produce.
- Never guess or hallucinate. If you don't know something, tell me honestly, or ask me follow-up questions.
- I prefer fixing things the Correct™ way. By Correct™ I mean the non-hacky, strategic, long-term-focused way, not a quick tactical way that gets the issue at hand fixed ASAP. Sometimes this is still fine though, but always negotiate with me about it.

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
