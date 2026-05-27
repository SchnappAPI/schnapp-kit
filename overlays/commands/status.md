---
name: status
description: Show current health of this project's stack. Delegates to scripts/status.sh if present; otherwise reports basic git state and process list. Projects supply their own scripts/status.sh to customize what "healthy" means for their stack.
disable-model-invocation: true
---

Show current project health.

1. Check for `scripts/status.sh` in the repo root. If it exists and is executable, run it and format the output. Done.

2. If `scripts/status.sh` does not exist, report a baseline summary:
   - **Git**: branch, last commit, ahead/behind origin.
   - **Processes**: any project-relevant background processes visible in `ps aux` (look for dev server, background workers).
   - **Environment**: confirm required env vars from `.env.template` are present (check for `op://` URIs — do not resolve them).

3. Report format — one section per checked area, one line per item:

```
Git:     <branch> — <short-sha> (<N> ahead / <N> behind origin)
Process: <name>: running | stopped
Env:     <VAR>: set | missing
```

---

**To customize `/status` for your project**, create `scripts/status.sh`:

```bash
#!/usr/bin/env bash
# Project-specific health checks for /status
echo "Service A: $(curl -sf http://localhost:3000/ping && echo ok || echo FAIL)"
echo "Service B: $(pgrep -f worker.py > /dev/null && echo running || echo stopped)"
```
