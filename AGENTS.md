# AGENTS.md

## Constitution Generation

This project uses a multi-agent constitution generation framework.
The resulting constitution is the current-system truth layer for downstream AI work:
spec, design, task composition, development, and QA.

**When asked to generate, analyse, or update the codebase constitution:**
→ Read and follow `.cursor/skills/constitution/SKILL.md` exactly.
→ Do NOT improvise or write a constitution directly. The skill defines a
  Prepare → Scan → Audit → Aggregate → Curate pipeline with parallel subagents.
→ Parallel mode requires Cursor 2.4+. Sequential fallback runs automatically on older versions.
→ Monorepo/workspace projects are auto-detected (pnpm, npm, nx, turbo, lerna).
→ Pipeline progress is tracked via `_status-*.json` files in `.cursor/constitution-tmp/`.
→ Re-runs produce a changelog at `docs/ai/constitution-changelog.md`.
→ Use `/constitution-patch` to correct errors — corrections survive re-runs.
→ Use `/constitution-incremental` for targeted updates after code changes.
→ Monorepo scaling with wave execution is automatic for large workspaces.
→ Treat the constitution as current-state truth and constraints, not as a feature spec.
→ Low-confidence or `[NEEDS REVIEW]` sections must not be treated as authoritative
  without human validation.

**When working on source code:**
→ Check `docs/ai/constitution-cheatsheet.md` for project conventions and rules.
→ For full detail, reference `docs/ai/constitution.md`.

**When working on downstream artifacts (spec/design/tasks/QA):**
→ Use the constitution to understand what already exists, what constraints must be
  preserved, and where the evidence is weak.
→ Let the spec define `what`; let the design define `how`.
