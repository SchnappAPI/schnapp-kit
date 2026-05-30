# Attribution

schnapp-kit was assembled from several open-source sources, then **flattened and
owned** — curated down to a focused set and merged into a single flat plugin.
There is no upstream re-sync; the sources below are credited as origin.

## Sources

- **[affaan-m/ECC](https://github.com/affaan-m/ECC)** — the bulk of the skills,
  agents, commands, and rules. Forked at commit
  `928076cc08cbb31e8549cea2883b4f51811de1c8` (2026-05-27), then pruned to a
  Python/TypeScript/SQL/infra stack and curated (see `docs/cleanup/MANIFEST.md`).
- **[mattpocock/skills](https://github.com/mattpocock/skills)** — engineering and
  productivity skills (`diagnose`, `tdd`, `prototype`, `handoff`, etc.). License
  preserved at `docs/guides/LICENSE-mattpocock-skills.txt`.
- **[anthropics/claude-code](https://github.com/anthropics/claude-code) plugins** —
  `agent-sdk-dev`, `plugin-dev`, `ralph-wiggum`, and `security-guidance`
  (agents, commands, skills, and hooks).

## License

This distribution is MIT-licensed (see `LICENSE`). Third-party material remains
under its respective upstream license.
