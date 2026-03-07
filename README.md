# Cursor Constitution Generator Kit

A drop-in multi-agent system for Cursor IDE that analyses a brownfield codebase and
produces `docs/ai/constitution.md` — a persistent AI-generation contract.

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
    │   └── constitution-auditor.md         ← Cross-validates all other agents
    ├── skills/
    │   ├── constitution/SKILL.md           ← Master orchestrator
    │   ├── constitution-aggregator/SKILL.md ← Merges verified reports
    │   └── constitution-curator/SKILL.md   ← Writes final constitution.md
    ├── rules/
    │   ├── constitution-mode.mdc           ← Pipeline discipline rules
    │   └── constitution-reference.mdc      ← Auto-checks constitution on code edits
    ├── hooks/
    │   └── constitution-drift.json         ← Drift detection on key files
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

- Cursor 2.4+ (for parallel subagent support)
- An existing codebase to analyse

## What it produces

`docs/ai/constitution.md` — full 12-section AI generation contract.
`docs/ai/constitution-cheatsheet.md` — condensed ~500-800 word version for agent context injection.
`docs/ai/constitution-viewer.html` — self-contained interactive browser UI. Just open the file.

## Pipeline

Pre-flight → Parallel Scan (up to 13 agents) → Audit → Aggregate → Curate

Estimated time: 10-25 minutes depending on codebase size.
