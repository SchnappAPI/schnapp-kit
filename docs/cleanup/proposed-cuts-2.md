# Proposed cuts — batch 2: agents · commands · rules · vendored (184)

Same review model: PROPOSAL only. Reply with deltas or "approve all".
Logic mirrors the skills batch (cut pruned-languages, niche verticals, ECC-internal).
Nothing deleted until confirmed.

**Tally:** propose KEEP 146 · propose CUT 38 · total 184


## AGENTS — KEEP 33 / CUT 13

**Propose CUT:**
- `chief-of-staff` — vert — personal comms (matches cut gtm/ops skills)
- `cpp-build-resolver` — lang-cpp — C++ not enabled
- `cpp-reviewer` — lang-cpp — C++ not enabled
- `gan-evaluator` — ecc-internal — GAN harness (gan-style-harness cut)
- `gan-generator` — ecc-internal — GAN harness (gan-style-harness cut)
- `gan-planner` — ecc-internal — GAN harness (gan-style-harness cut)
- `healthcare-reviewer` — vert-health
- `homelab-architect` — vert-network
- `marketing-agent` — vert-gtm — marketing
- `network-architect` — vert-network
- `network-config-reviewer` — vert-network
- `network-troubleshooter` — vert-network
- `seo-specialist` — vert-gtm — SEO

**Propose KEEP (33):** `a11y-architect`, `architect`, `build-error-resolver`, `code-architect`, `code-explorer`, `code-reviewer`, `code-simplifier`, `comment-analyzer`, `conversation-analyzer`, `database-reviewer`, `django-build-resolver`, `django-reviewer`, `doc-updater`, `docs-lookup`, `e2e-runner`, `fastapi-reviewer`, `harness-optimizer`, `loop-operator`, `mle-reviewer`, `opensource-forker`, `opensource-packager`, `opensource-sanitizer`, `performance-optimizer`, `planner`, `pr-test-analyzer`, `python-reviewer`, `pytorch-build-resolver`, `refactor-cleaner`, `security-reviewer`, `silent-failure-hunter`, `tdd-guide`, `type-design-analyzer`, `typescript-reviewer`

## COMMANDS — KEEP 52 / CUT 12

**Propose CUT:**
- `auto-update` — ecc-internal — pulls/reinstalls ECC
- `cost-report` — ecc-internal — cost-tracking skill cut
- `cpp-build` — lang-cpp
- `cpp-review` — lang-cpp
- `cpp-test` — lang-cpp
- `ecc-guide` — ecc-internal
- `gan-build` — ecc-internal — GAN (cut)
- `gan-design` — ecc-internal — GAN (cut)
- `gradle-build` — lang-java/kotlin — Gradle
- `jira` — vert — jira-integration cut
- `marketing-campaign` — vert-gtm
- `project-init` — ecc-internal — ECC onboarding

**Propose KEEP (52):** `aside`, `build-fix`, `checkpoint`, `code-review`, `evolve`, `fastapi-review`, `feature-dev`, `harness-audit`, `hookify`, `hookify-configure`, `hookify-help`, `hookify-list`, `instinct-export`, `instinct-import`, `instinct-status`, `learn`, `learn-eval`, `loop-start`, `loop-status`, `model-route`, `multi-backend`, `multi-execute`, `multi-frontend`, `multi-plan`, `multi-workflow`, `plan`, `plan-prd`, `pm2`, `pr`, `projects`, `promote`, `prp-commit`, `prp-implement`, `prp-plan`, `prp-pr`, `prp-prd`, `prune`, `python-review`, `quality-gate`, `refactor-clean`, `resume-session`, `review-pr`, `santa-loop`, `save-session`, `security-scan`, `sessions`, `setup-pm`, `skill-create`, `skill-health`, `test-coverage`, `update-codemaps`, `update-docs`

## RULES — KEEP 29 / CUT 10

**Propose CUT:**
- `angular/coding-style` — lang-angular — not enabled
- `angular/hooks` — lang-angular — not enabled
- `angular/patterns` — lang-angular — not enabled
- `angular/security` — lang-angular — not enabled
- `angular/testing` — lang-angular — not enabled
- `cpp/coding-style` — lang-cpp — not enabled
- `cpp/hooks` — lang-cpp — not enabled
- `cpp/patterns` — lang-cpp — not enabled
- `cpp/security` — lang-cpp — not enabled
- `cpp/testing` — lang-cpp — not enabled

**Propose KEEP (29):** `README`, `common/agents`, `common/code-review`, `common/coding-style`, `common/development-workflow`, `common/git-workflow`, `common/hooks`, `common/patterns`, `common/performance`, `common/security`, `common/testing`, `python/coding-style`, `python/fastapi`, `python/hooks`, `python/patterns`, `python/security`, `python/testing`, `typescript/coding-style`, `typescript/hooks`, `typescript/patterns`, `typescript/security`, `typescript/testing`, `web/coding-style`, `web/design-quality`, `web/hooks`, `web/patterns`, `web/performance`, `web/security`, `web/testing`

## VENDORED — KEEP 32 / CUT 3

**Propose CUT:**
- `mattpocock-skills/skills/misc/scaffold-exercises/SKILL` — niche — course-exercise scaffolding
- `mattpocock-skills/skills/personal/edit-article/SKILL` — vert-gtm — article editing
- `mattpocock-skills/skills/productivity/caveman/SKILL` — niche — novelty terse-mode

**Propose KEEP (32):** `agent-sdk-dev/agents/agent-sdk-verifier-py`, `agent-sdk-dev/agents/agent-sdk-verifier-ts`, `agent-sdk-dev/commands/new-sdk-app`, `mattpocock-skills/skills/engineering/diagnose/SKILL`, `mattpocock-skills/skills/engineering/grill-with-docs/SKILL`, `mattpocock-skills/skills/engineering/improve-codebase-architecture/SKILL`, `mattpocock-skills/skills/engineering/prototype/SKILL`, `mattpocock-skills/skills/engineering/setup-matt-pocock-skills/SKILL`, `mattpocock-skills/skills/engineering/tdd/SKILL`, `mattpocock-skills/skills/engineering/to-issues/SKILL`, `mattpocock-skills/skills/engineering/to-prd/SKILL`, `mattpocock-skills/skills/engineering/triage/SKILL`, `mattpocock-skills/skills/engineering/zoom-out/SKILL`, `mattpocock-skills/skills/misc/git-guardrails-claude-code/SKILL`, `mattpocock-skills/skills/misc/setup-pre-commit/SKILL`, `mattpocock-skills/skills/productivity/grill-me/SKILL`, `mattpocock-skills/skills/productivity/handoff/SKILL`, `mattpocock-skills/skills/productivity/write-a-skill/SKILL`, `plugin-dev/agents/agent-creator`, `plugin-dev/agents/plugin-validator`, `plugin-dev/agents/skill-reviewer`, `plugin-dev/commands/create-plugin`, `plugin-dev/skills/agent-development/SKILL`, `plugin-dev/skills/command-development/SKILL`, `plugin-dev/skills/hook-development/SKILL`, `plugin-dev/skills/mcp-integration/SKILL`, `plugin-dev/skills/plugin-settings/SKILL`, `plugin-dev/skills/plugin-structure/SKILL`, `plugin-dev/skills/skill-development/SKILL`, `ralph-wiggum/commands/cancel-ralph`, `ralph-wiggum/commands/help`, `ralph-wiggum/commands/ralph-loop`
