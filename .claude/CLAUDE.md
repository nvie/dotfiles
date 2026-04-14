# General instructions

- When reporting information to me, be extremely concise and sacrifice grammar for the sake of concision.
- Don't overdo em-dashes in output I'm asking you to produce.
- Never guess or hallucinate. If you don't know something, tell me honestly, or ask me follow-up questions.

# Local Turbo commands

I have some personal aliases:

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

# General workflow

- Never start dev servers yourself -- I run them manually
- When committing multiple changes, commit each atomic change separately
- Reuse existing components/utilities -- never duplicate or reinvent
