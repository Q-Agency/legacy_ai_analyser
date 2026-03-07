---
name: constitution
description: >
  Orchestrate full codebase analysis to produce docs/ai/constitution.md.
  Handles pre-flight setup, parallel scanning, auditing, aggregation, and
  curation. Invoke with /constitution or "generate constitution" or
  "analyse codebase for AI constitution".
version: 2.0.0
---

# Codebase Constitution Generator

## Purpose

Produce `docs/ai/constitution.md` — a durable, audited AI-generation contract
for a brownfield project — by running a Prepare → Map → Audit → Reduce → Curate
pipeline using parallel Cursor subagents.

## Phase 0: Pre-flight (do this before spawning any subagent)

### 0a. Create directory structure
```bash
mkdir -p .cursor/constitution-tmp
mkdir -p docs/ai/constitution-fragments
```

### 0b. Generate .cursorignore
If `.cursorignore` does not exist, create it now using the baseline template from
section 5 of this architecture guide. If it exists, read it and confirm it covers:
- node_modules/, dist/, build/, coverage/
- *.lock, *.generated.*, *.min.js
- .env, *.pem, secrets/

If any of those are missing, add them before proceeding.

### 0c. Inventory the codebase
```bash
find . -type d -not -path "*/node_modules/*" -not -path "*/.git/*" \
       -not -path "*/dist/*" -not -path "*/build/*" \
       -not -path "*/.cursor/*" -not -path "*/docs/ai/*" \
       -maxdepth 3
```

Identify top-level domain directories (typically 4-12). This determines how many
domain-scanner instances to spawn.

## Phase 1: Parallel scan

Spawn these agents simultaneously (all can run in parallel):

**Domain scanners** — one instance per top-level domain directory:
- Tell each: "Scan the directory `<path>` as domain `<label>`"
- Maximum 8 domain scanners in parallel
- If >8 domains: group smaller dirs, or run in two batches

**Specialist analysts** — spawn all five simultaneously:
- `api-contract-analyst` — full codebase scope
- `data-model-analyst` — full codebase scope
- `dependency-analyst` — full codebase scope
- `pattern-analyst` — full codebase scope
- `runtime-flow-analyst` — full codebase scope

Wait for ALL phase 1 agents to complete before moving to phase 2.
Check completion by verifying their output files exist in `.cursor/constitution-tmp/`.

## Phase 2: Audit

Spawn `constitution-auditor`.
Wait for `audit-report.json` to appear in `.cursor/constitution-tmp/`.
Report audit results to user: "Audit complete: <confidence>, <count> contested claims."
If overall_confidence is "low": ask user if they want to re-run specific agents.

## Phase 3: Aggregate

Invoke the `constitution-aggregator` skill.

## Phase 4: Curate

Invoke the `constitution-curator` skill.

## Phase 5: Finalise

1. Verify `docs/ai/constitution.md` exists
2. Verify `docs/ai/constitution-cheatsheet.md` exists
3. Verify `docs/ai/constitution-viewer.html` exists
4. Report section count and word estimate for constitution and cheat sheet
5. Report: "Viewer available at docs/ai/constitution-viewer.html — open in browser"
6. Ask: "Would you like to expand any section or re-run specific analysts?"
7. Offer to clean up: `rm -rf .cursor/constitution-tmp/`
   (keep `docs/ai/constitution-fragments/` — these are useful for re-runs)

## Error handling

- Subagent fails to write output: retry once with the same prompt
- Directory too large (>500 files): split into subdirectories, spawn two scanners
- Malformed JSON: ask that subagent to re-write its output file
- Audit finds low confidence: do not hide this — surface it clearly in the constitution
