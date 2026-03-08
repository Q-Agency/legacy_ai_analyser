# Cursor Constitution Generator Kit

A drop-in multi-agent system for Cursor IDE that analyses a brownfield codebase and
produces `docs/ai/constitution.md` — a persistent AI-generation contract and
current-system truth layer for downstream AI workflows.

The constitution is meant to ground later stages such as:
- spec creation (`what` should change)
- design (`how` the change fits the current system)
- task composition
- development
- QA

It does not replace spec or design. It gives those stages a brownfield baseline
derived from the existing codebase.

## What's in the box

```
constitution-kit/
├── install.sh                              ← Run this in your project root
├── pre-commit-hook.sh                      ← Optional git hook for drift detection
├── .cursorignore                           ← Baseline AI context exclusions
└── .cursor/
    ├── agents/
    │   ├── domain-scanner.md               ← One instance per directory
    │   ├── api-contract-analyst.md         ← Maps all API surfaces
    │   ├── data-model-analyst.md           ← Schemas, entities, data flow
    │   ├── dependency-analyst.md           ← Tech stack and package health
    │   ├── pattern-analyst.md              ← Architecture and coding patterns
    │   ├── runtime-flow-analyst.md         ← Actual request/event call chains
    │   ├── infra-analyst.md               ← Infrastructure, CI/CD, deployment
    │   └── constitution-auditor.md         ← Cross-validates all other agents
    ├── skills/
    │   ├── constitution/SKILL.md           ← Master orchestrator
    │   ├── constitution-aggregator/SKILL.md ← Merges verified reports
    │   ├── constitution-curator/SKILL.md   ← Writes final constitution.md
    │   ├── constitution-patch/SKILL.md     ← Manual corrections with logging
    │   └── constitution-incremental/SKILL.md ← Incremental updates via git diff
    ├── rules/
    │   ├── constitution-mode.mdc           ← Pipeline discipline rules
    │   └── constitution-reference.mdc      ← Auto-checks constitution on code edits
    ├── hooks/
    │   ├── constitution-drift.json         ← Hook source template (installed as .cursor/hooks.json)
    │   └── constitution-drift-check.sh     ← Drift detection script
    └── constitution-tmp/
        └── .gitignore                      ← Scratch space, excluded from git
```

## Quick start

```bash
cd /path/to/your/project
bash /path/to/constitution-kit/install.sh
```

Then open the project in Cursor and type in agent chat:

```
Generate a constitution for this codebase
```

## Requirements

- **Cursor 2.4+** recommended (parallel subagent support)
- **Cursor < 2.4** supported via sequential fallback mode (slower but functional)
- An existing codebase to analyse
- Monorepo/workspace projects supported (pnpm, npm, nx, turbo, lerna)

## What it produces

- `docs/ai/constitution.md` — full 13-section constitution with section-level confidence,
  evidence sources, and downstream-use guidance
- `docs/ai/constitution-cheatsheet.md` — condensed ~500-800 word version for agent context injection
- `docs/ai/constitution-viewer.html` — self-contained interactive browser UI. Just open the file
- `docs/ai/constitution-changelog.md` — section-by-section diff when re-running (created on second run and onwards)

## Why this exists

Greenfield projects can start with an intentional constitution from day one.
Legacy systems cannot. This framework infers the constitution from the existing
code so downstream AI steps do not start from a blank context window.

## Pipeline

Pre-flight → Parallel Scan (up to 14 agents) → Audit → Aggregate → Curate

Incremental mode available: re-runs only agents affected by recent changes.
Manual corrections via `/constitution-patch` persist across re-runs.
Monorepo scaling with wave execution for large workspaces.

Sequential fallback available for older Cursor versions.

Estimated time: 10-25 minutes (parallel) or 30-60 minutes (sequential) depending on codebase size.
