---
paths:
  - "docs/**"
---

- README invariant sections: edit via targeted replacement on the specific section. Never rewrite a full README.
- ADRs live one-per-file under `docs/decisions/` (or `docs/adr/` per project convention). Naming: `ADR-YYYYMMDD-N-slug.md`. Use the `/adr` command — it computes the counter.
- ADR body fields: `Date:`, `Context:`, `Decision:`, `Consequences:`, optional `Supersedes:`. Append-only — never edit a shipped ADR; supersede it with a new one.
- Changelog: there is no CHANGELOG file. The commit subject **is** the changelog entry. Format: `<type>: [scope] description — ADR-YYYYMMDD-N (optional)`. Long-form context lives in the ADR or commit body, not a separate doc.
- Session lifecycle documentation lives in root `CLAUDE.md` only. Do not duplicate it in `docs/README.md` or elsewhere.
- Generated files are git-ignored. Regenerate locally via project-specific commands; do not commit generated artifacts unless the project explicitly opts in.
- Feature specs (methodology, research, design) live under `docs/features/`. Operational runbooks live under `docs/runbooks/`. Do not conflate Claude Code skills (under `.claude/skills/`) with feature specs.
