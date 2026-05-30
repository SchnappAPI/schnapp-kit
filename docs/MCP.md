# MCP servers

The kit ships a project-scoped `.mcp.json` so the MCP servers you use most are
defined once and travel with the repo.

## What ships

| Server | Type | Auth | Toolsets |
|--------|------|------|----------|
| `github` | `http` → `https://api.githubcopilot.com/mcp/` | `Authorization: Bearer ${GITHUB_TOKEN}` | `all` (via `X-MCP-Toolsets`) |

## Toolsets

The GitHub MCP server groups its ~160 tools into ~18 **toolsets**. With no
header you get only the defaults (`context, repos, issues, pull_requests,
users`). The kit requests **`all`** via the `X-MCP-Toolsets` header so the
`actions` (CI logs + re-run failed jobs), `code_security`, `dependabot`,
`secret_protection`, `notifications`, and other toolsets are available:

```json
"headers": {
  "Authorization": "Bearer ${GITHUB_TOKEN}",
  "X-MCP-Toolsets": "all"
}
```

To narrow the surface, replace `all` with a comma-separated list, e.g.
`"context,repos,issues,pull_requests,actions"`. Other supported headers:
`X-MCP-Readonly: "true"` (read-only — note the kit creates/merges PRs, so
read-write is the default here) and `X-MCP-Insiders: "true"`.

> **Not available via MCP:** editing a repository's description / topics /
> homepage. No GitHub MCP toolset exposes repository-settings editing — use
> `gh repo edit` or the web UI for that.

## Approval (why it won't connect on its own)

Project-scoped servers from `.mcp.json` are **not** auto-connected. Claude Code
lists them as *pending approval* until you explicitly approve them — this is a
security boundary, so a repo can't silently start MCP servers. Approve with:

```
/mcp            # inside a session — approve "github"
claude mcp list # shows ⏸ pending approval until then
```

If you ever need to re-prompt: `claude mcp reset-project-choices`.

## Token

Set a GitHub token in your environment before approving (or the `Bearer` header
expands empty and auth fails):

```
export GITHUB_TOKEN=ghp_xxx   # a PAT, or a fine-grained token
```

`${VAR}` expansion works in `.mcp.json` string values, including inside
`headers` — no secret is committed to the repo.

## Adding more servers

Add entries under `mcpServers`. HTTP and stdio are both supported:

```jsonc
{
  "mcpServers": {
    "github": {
      "type": "http",
      "url": "https://api.githubcopilot.com/mcp/",
      "headers": { "Authorization": "Bearer ${GITHUB_TOKEN}" }
    },
    "some-local-tool": {
      "type": "stdio",
      "command": "${CLAUDE_PROJECT_DIR}/bin/server",
      "env": { "API_KEY": "${SOME_API_KEY}" }
    }
  }
}
```

`validate-manifests.sh` checks that `.mcp.json` is valid JSON with an
`mcpServers` object, so a malformed edit fails CI.
