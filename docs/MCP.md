# MCP servers

The kit ships a project-scoped `.mcp.json` so the MCP servers you use most are
defined once and travel with the repo.

## What ships

| Server | Type | Auth |
|--------|------|------|
| `github` | `http` → `https://api.githubcopilot.com/mcp/` | `Authorization: Bearer ${GITHUB_TOKEN}` |

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
