---
name: audit-against-kit
description: Scan one of the user's project repos and produce a delta report vs schnapp-kit. Use when the user says "audit <repo> against the kit", "what does the kit miss for <repo>", "where does <repo> conflict with the kit", or `/audit-against-kit <repo>`. Four-section output: uncovered conventions, promotion candidates, duplicates, conflicts.
---

# audit-against-kit

Reverse-direction pass: given a project repo, surface where schnapp-kit doesn't meet its needs and where its conventions conflict with the kit's.

## When to use

- User invokes `/audit-against-kit <repo-url-or-path>`.
- User asks "audit my repo against the kit", "what's the kit missing for X", "what does X disagree with the kit on".
- Before adopting the kit in a project, to know what reconciliation work is ahead.
- Periodically on the user's main repos to catch drift.

## Inputs

- **`<repo-url-or-path>`** (required) — GitHub URL or local path.
- **`--write KIT-AUDIT.md`** (optional) — drop the report into the audited repo's root.
- **`--open-pr`** (optional) — open a draft PR to schnapp-kit with the proposed overlays/language-pack additions.

## Procedure

1. **Resolve source.** Same as `discover-kit-additions`.
2. **Build kit catalog** (same indexing as `discover-kit-additions`).
3. **Detect repo's tech profile.**
   - Languages present (by file extension, manifests like `package.json`, `pyproject.toml`, etc.).
   - Conventions present:
     - Commit-msg format (sample last 50 commits, identify pattern).
     - ADR location (`docs/decisions/`, `docs/adr/`, `architecture/decisions/`, none).
     - Secrets handling (`.env`, `.env.example`, `.env.template`, secrets manager references, `secrets.*` in workflows).
     - Hook presence (`.githooks/`, `.husky/`, `.claude/hooks/`).
4. **Compare and bucket into four sections.**

   ### Section 1: Uncovered languages or conventions
   - Languages in the repo that no enabled `language-packs/*/` covers.
   - Conventions present in the repo that the kit doesn't represent (e.g. changelog format the kit has no rule for).

   ### Section 2: Promotion candidates
   - Repo-local artifacts (in `.claude/`, `.cursor/`, `agents/`, etc.) that have no kit equivalent and look universal enough to belong in `overlays/` or a language pack.
   - For each: source path + a paste-ready `/promote-from-project` command.

   ### Section 3: Duplicates
   - Repo-local artifacts that already exist in the kit. Per duplicate, recommend:
     - **Use kit version, delete local** — if local is identical or worse.
     - **Use kit version with overlay overrides** — if local has small useful customizations.
     - **Back-promote local → kit** — if local is better; suggests merging.

   ### Section 4: Conflicts
   - Direct contradictions between repo conventions and kit conventions. Common cases:
     - ADR path mismatch (e.g. repo uses `docs/decisions/`, mattpocock-skills expects `docs/adr/`).
     - Commit-msg format divergence (repo's format vs `overlays/hooks/git/commit-msg`).
     - Secrets-handling rule conflicts (repo stores plaintext envs, kit's `rules/secrets.md` forbids).
     - Hook overlap (repo has a `commit-msg` that disagrees with the kit's).
   - For each conflict, recommend one of:
     - **Project-side fix** — change the repo to match the kit. Explain the diff.
     - **Kit-side fix** — change the kit to accommodate (only when the repo convention is clearly more general).
     - **Document as intentional deviation** — write an ADR in the repo acknowledging the divergence; emit a paste-ready ADR template.

5. **Emit report** as structured markdown with the four sections, a summary header, and a "Next actions" checklist.

6. **If `--write KIT-AUDIT.md`**, drop the report into the audited repo's root (do not commit; let the user review first).

7. **If `--open-pr`**, build a branch on schnapp-kit containing the Section 2 promotions and the Section 1 language-pack stubs, push, and open a draft PR titled "audit-against-kit: deltas from <repo>".

## Output format

```markdown
# Audit report — <repo> vs schnapp-kit @ <kit-version>

Summary: <N1> uncovered, <N2> promotion candidates, <N3> duplicates, <N4> conflicts

## 1. Uncovered languages or conventions

- [language: rust] No `language-packs/rust/`. Files affected: <count>. Suggested: scaffold pack via `scripts/add-language-pack.sh rust`.
- [convention: changelog-format] Repo uses Keep-A-Changelog; kit has no rule. Suggested: add `overlays/rules/changelogs.md`.

## 2. Promotion candidates

| Artifact | Source path | Why universal | Promote command |
| -------- | ----------- | ------------- | --------------- |

## 3. Duplicates

| Artifact | Local path | Kit path | Recommendation |
| -------- | ---------- | -------- | -------------- |

## 4. Conflicts

### 4.1 ADR path mismatch

- Repo: `docs/decisions/`
- Kit (via vendored mattpocock-skills): expects `docs/adr/`
- Recommended fix: project-side — `ln -s decisions docs/adr` in the repo.

## Next actions

- [ ] `/promote-from-project .claude/skills/<foo> --type skill --name foo`
- [ ] In project repo: `ln -s decisions docs/adr && git add docs/adr && commit`
```

## Failure modes

- Repo doesn't use Claude Code conventions at all → emit "no Claude Code artifacts detected" but still run the language and convention diff.
- Network/git failure → fall back to MCP-based read with reduced scope; document the partial-scan caveat in the report header.

## Composes with

- `/discover-kit-additions <repo>` — the inverse direction.
- `/promote-from-project <path>` — executes Section 2 actions.
- `/sync-upstreams` — periodically re-run after sync to catch new conflicts.
