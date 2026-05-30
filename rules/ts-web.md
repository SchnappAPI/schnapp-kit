---
paths:
  - "**/*.ts"
  - "**/*.tsx"
  - "**/tsconfig.json"
  - "**/*.css"
---

# TypeScript / Next.js 15 conventions

- **Never hardcode hostnames, IPs, or connection strings.** Read from `process.env.*`. Environment-specific values belong in env config, not source.
- **Validate TypeScript before committing:** `cd <app-dir> && npx --no-install tsc --noEmit -p .`. Run from the directory containing `tsconfig.json` — running from repo root with a relative `-p` flag silently returns exit 0 (false negative).
- **`tsc` must be run from the app directory.** Canonical form: `cd /path/to/app && npx --no-install tsc --noEmit -p .`. Empty stdout is only valid if the `cd` happened.
- **Next.js dev server:** prefer `next dev` over `next dev --turbopack` until the turbopack manifest race is resolved upstream. Symptom: `Internal Server Error` in browser + dev log spam of `ENOENT: ... _buildManifest.js.tmp.<random>`. Recovery: `pkill -f "next dev" && rm -rf .next && restart`.
- **`revalidateOnFocus: false`** on all SWR hooks — prevents spurious refetches on window focus in data-heavy UIs.
- **Deploy via CI workflow only.** Never build locally and copy artifacts to production.
- **UI change verification:** hit the changed surface in the dev browser before stacking the next UI commit. Even a `curl` and grep for expected text counts. Stacking 3+ UI commits without any verification is a documented failure mode.
- **Non-ASCII Unicode in files:** use your CI-based create/update mechanism, not direct file push tools that may corrupt multi-byte characters.
