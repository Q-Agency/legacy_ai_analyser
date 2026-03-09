---
name: constitution-curator
description: >
  Reads .cursor/constitution-tmp/_merged.json and writes the final outputs:
  docs/ai/full-analysis-YYYY-MM-DD.md (detailed reference),
  docs/ai/CONSTITUTION.md (compact cornerstone for downstream agents),
  docs/ai/constitution-viewer.html (interactive viewer from full analysis).
  Invoke after aggregation completes.
version: 3.0.0
---

# Constitution Curator

## Purpose

Produce four artifacts from the merged, audited intermediate data:

1. **`docs/ai/full-analysis-YYYY-MM-DD.md`** — the detailed 13-section reference
   document. Used by the viewer and for human browsing. Can be re-generated
   periodically. Replaces the previous `docs/ai/constitution.md`.
2. **`docs/ai/CONSTITUTION.md`** — the compact, fixed cornerstone (~600-800 words)
   passed to every downstream agent (spec, design, tasks, code, review, QA).
   This is the primary output. Replaces the previous `docs/ai/constitution-cheatsheet.md`.
3. **`docs/ai/constitution.json`** — machine-readable version of the constitution
   for downstream agents that need structured lookups (e.g. "what's the ORM?",
   "what auth strategy?", "list all DO NOT rules"). First-class output, not an
   intermediate artifact.
4. **`docs/ai/constitution-viewer.html`** — self-contained interactive viewer
   fed from the full analysis data.

## Steps

1. Read `.cursor/constitution-tmp/_merged.json`
2. Also read all `docs/ai/constitution-fragments/*.md` for narrative context
3. Write `docs/ai/full-analysis-YYYY-MM-DD.md` following the Full Analysis Template below
   - Use today's date in the filename and as the version
   - Include all 13 sections with confidence, evidence, and downstream-use metadata
   - For any section with `needs_human_review: true`: add a visible warning block
4. Write `docs/ai/CONSTITUTION.md` following the CONSTITUTION Template below
   - This is the compact cornerstone: ~600-800 words, 10 sections
   - ALL 10 sections MUST be present (see Section Contract below)
   - Reference the full analysis baseline date
   - DO and DO NOT rules are the most critical part — be specific and file-referenced
5. Write `docs/ai/constitution.json` following the JSON Schema Template below
   - Machine-readable structured data for downstream agent consumption
   - Curated from `_merged.json` — not a raw copy, but a clean public contract
6. Generate `docs/ai/constitution-viewer.html` (see Viewer Template below)
   - Fed from the full analysis data, not the compact CONSTITUTION
7. Report: "Full analysis written — <section count> sections, ~<word count> words.
   CONSTITUTION.md written — ~<word count> words. constitution.json written.
   Viewer generated."

## CONSTITUTION Template (compact cornerstone)

This is the primary downstream artifact. Keep it under 800 words. Every downstream
agent (spec, design, tasks, code, review, QA) receives this as context.

```markdown
# [Project Name] — CONSTITUTION

> **Baseline:** YYYY-MM-DD
> **Role:** Fixed cornerstone for all downstream agents (spec, design, tasks, code, review, QA).
> The spec defines WHAT. The design defines HOW. This document defines WITHIN WHAT.

## System

[1-2 lines: name, stack (framework + language + runtime), what it does, package manager, module format]

## Architecture

[2-3 lines: architectural style, layers, domains, cross-domain communication pattern]

## Tech Stack

[Table of key dependencies with version and role — only the ones that matter for generation]
[1 line: forbidden additions / hard constraints]

## Design Patterns

[5-6 bullet points: the established patterns that all new code must follow.
 E.g. "API module per domain", "Hook per domain wrapping API", "Central HTTP client",
 "SSE via ReadableStream", "Response normalization at API boundary", etc.]

## File Structure

[Code block showing where new features go:
 src/api/<domain>.ts, src/hooks/use<Domain>.ts, src/components/<Name>.tsx, etc.]

## Naming

[4-5 lines: file naming, variable/function naming, component/type naming,
 hook naming, constant naming, API-backed field naming]

## Code Rules

[4-5 lines: error handling pattern, async pattern, import rules, state management, AbortSignal]

## Testing

[3-4 lines: framework, location, mocking approach, coverage target, known gaps]

## DO

[6-10 numbered items, file-referenced, actionable]

## DO NOT

[5-10 numbered items, file-referenced, actionable.
 Fold in key HIGH AI-risk debt items and sensitive zone warnings here.]
```

### Section Contract (guaranteed structure)

Downstream agents MAY rely on these exact heading names being present. Every section
MUST appear in every generated CONSTITUTION.md, even if data is sparse. If a section
has insufficient data, include it with a one-line note: `No data available — see full analysis.`

| # | Heading | Guaranteed content | Downstream use |
|---|---------|-------------------|----------------|
| 1 | `## System` | Name, stack, runtime, package manager, module format | All agents: orient on what this project is |
| 2 | `## Architecture` | Style, layers, domains, communication pattern | Design/task agents: understand boundaries |
| 3 | `## Tech Stack` | Dependency table + hard constraints | All agents: never introduce unlisted deps |
| 4 | `## Design Patterns` | Bullet list of established patterns | Implementation agents: follow, don't invent |
| 5 | `## File Structure` | Code block showing where new features go | Implementation agents: place files correctly |
| 6 | `## Naming` | Naming conventions per category | Implementation agents: consistent naming |
| 7 | `## Code Rules` | Error handling, async, imports, state | Implementation agents: code style |
| 8 | `## Testing` | Framework, location, mocking, coverage | QA/implementation agents: write correct tests |
| 9 | `## DO` | Numbered, file-referenced, actionable rules | All agents: positive constraints |
| 10 | `## DO NOT` | Numbered, file-referenced, actionable rules | All agents: negative constraints |

Downstream agents can reference sections by heading name (e.g., "read the `## DO NOT`
section of CONSTITUTION.md") and be guaranteed it exists.

### CONSTITUTION rules

- Target 600-800 words maximum
- ALL 10 sections listed in the Section Contract MUST be present — no omissions
- DO and DO NOT rules must be specific and file-referenced — these are the highest-value content
- Fold HIGH AI-risk debt items into DO NOT (don't keep a separate debt section)
- Fold sensitive zone warnings into DO NOT where relevant
- Do NOT include: endpoint inventories, entity maps, runtime flow traces, infrastructure
  details, analysis metadata, confidence tables, or changelog. Those live in the full analysis.
- Do NOT include section-level confidence/evidence/downstream-use metadata blocks.
  The compact constitution is a rules document, not an audit report.
- Do NOT add, rename, or reorder sections beyond the 10 defined in the Section Contract.
  Downstream agents depend on this exact structure.

## Full Analysis Template

Write `docs/ai/full-analysis-YYYY-MM-DD.md` using today's date in the filename and as
the version. Include per-section confidence, evidence sources, and downstream-use metadata.
Add `[NEEDS REVIEW]` warning blocks where the aggregator flagged `needs_human_review`.

````markdown
# Full Analysis — [Project Name]

> **Version:** YYYY-MM-DD
> **Generated:** [date]
> **Method:** Cursor multi-agent analysis (domain-scanner × N, api-contract-analyst,
> data-model-analyst, dependency-analyst, pattern-analyst, runtime-flow-analyst,
> infra-analyst, constitution-auditor)
> **Overall confidence:** [from audit report]

---

> ⚠️ **Sections marked [NEEDS REVIEW]** contain claims that the auditor could not
> fully verify or that were contested across multiple reports. Do not treat these
> as authoritative without human validation.

---

For every numbered section below, include this metadata block immediately after the heading:

**Confidence:** [high|medium|low]
**Evidence sources:** [`<path-or-report>`, `<path-or-report>`]
**Downstream use:** [how downstream spec/design/tasks/dev/QA should use this section]

---

## 1. Project Identity

**Name:** [from package.json or inferred]
**Type:** [Web app / API / Mobile backend / Monorepo / Library]
**Primary language:** [language(s) with approx % split]
**Runtime:** [Node 20.x / Python 3.11 / JVM 17 / etc. — exact version]
**Primary framework:** [Next.js 14 / NestJS 10 / Django 4.2 / etc. — exact version]

**System description:**
[2-3 sentences: what it does, who uses it, what problem it solves — inferred from code]

---

## 2. Architecture Overview

**Architectural style:** [Clean Architecture / Layered MVC / Hexagonal / Microservices]
**Layers:** [list layers in order with one-line description each]

**Directory map:**
```
[reproduce key directory tree with one-line annotation per dir]
```

**Domain inventory:**
| Domain | Path | Responsibility | Confidence |
|--------|------|----------------|------------|
[one row per domain from domain-scanner reports]

### Domain boundaries
[Describe the domain seams that downstream design work must preserve:
ownership boundaries, allowed cross-domain calls, and where shared abstractions live.]

**Cross-domain communication:** [how domains interact — direct import / events / REST / etc.]

---

## 3. Tech Stack Contract

> Treat this section as a constraint, not a suggestion. AI generation must not
> introduce dependencies outside this list without explicit human approval.

**Runtime:** [exact version]
**Framework:** [name + exact version]
**Package manager:** [npm/yarn/pnpm] — use exclusively, never mix
**Monorepo tool:** [nx/turborepo/lerna/none]

### Core dependencies
| Package | Version | Role | Generation notes |
|---------|---------|------|-----------------|
[top 20 dependencies with role and any AI-generation notes]

### Hard constraints
- Node/Python/Java version: [exact — enforce, do not upgrade without team decision]
- Import style: [ESM/CommonJS — do not mix]
- [any other hard constraints from dependency-analyst]

---

## 4. Data Model

**Database:** [type]
**ORM:** [name + version]
**Schema location:** [`<path>`]

### Entity map
| Entity | Table/Collection | Key Relations | Notes |
|--------|-----------------|---------------|-------|
[one row per entity]

### Data flow
[Describe the standard path: request → controller → service → repository → DB
and the return path. Be specific about where validation happens, where transactions start.]

### Data invariants
- [What must always remain true in the data model]
- [Where referential or business invariants are enforced]
- [What downstream changes must not violate]

### Naming conventions
- Tables: [pattern]
- Columns: [pattern]
- IDs: [UUID/auto-increment/ULID + where generated]

### Issues [NEEDS REVIEW if flagged]
[List from data-model audit with severity]

---

## 5. API Contract

**Style:** [REST/GraphQL/gRPC/mixed]
**Auth:** [JWT Bearer / API key / session / OAuth2 — describe exactly]
**Versioning:** [URL prefix /v1 / header / none]
**Base URL pattern:** [/api/v1/...]

### Endpoint inventory
[Group by domain. For each: METHOD /path — auth requirement — brief description]

### Request/Response conventions
- Content-Type: [value]
- Error format: [describe the standard error shape with example]
- Pagination: [describe the pattern]
- Dates: [ISO 8601 / Unix timestamp / etc.]

### Integration points
[List the external and internal contract boundaries that downstream specs/designs must
respect: public APIs, event schemas, webhook formats, SDK consumers, versioned endpoints.]

---

## 6. Runtime Behaviour

> This section captures what static analysis cannot: how the system actually
> behaves when a request arrives. AI generation MUST respect these flows.

### Entry points
| Type | File | Description |
|------|------|-------------|
[from runtime-flow-analyst]

### Middleware execution chain
[List in order with purpose. This is the execution context for every request.]

### Key traced flows
[For each traced flow: name, entry point, layer-by-layer call chain, side effects]

### Global side effects
[Things that happen on every request regardless — audit logging, rate limiting, etc.]

### Operational invariants
- [Middleware or interceptor ordering that must not be broken]
- [Auth, tenancy, transaction, caching, or streaming rules that are implicit but critical]
- [Other hidden runtime assumptions downstream implementation must preserve]

### AI generation note
> When adding new endpoints or operations:
> [List specific rules derived from runtime-flow analysis]

---

## 7. Infrastructure & Deployment

> This section captures how the system is built, tested, containerised, and deployed.
> AI generation must respect these operational constraints.

**Deployment targets:**
| Target | Platform | Strategy | Config |
|--------|----------|----------|--------|
[from infra-analyst — one row per deployment target]

**CI/CD pipelines:**
| Pipeline | Platform | Triggers | Stages |
|----------|----------|----------|--------|
[from infra-analyst — one row per pipeline]

**Containerisation:**
- Dockerfiles: [list]
- Base images: [list]
- Multi-stage builds: [yes/no]
- Compose files: [list or "none"]

**Build pipeline:**
[Describe the build → test → deploy flow from CI/CD config]

**Deployment topology:**
[Describe how components connect in production — single container, multi-service, serverless, etc.]

### Operational constraints
- [Deployment/runtime assumptions that shape design choices]
- [CI/CD, build, or platform requirements downstream tasks must preserve]
- [Environment or topology limits that make some implementations unsafe]

### Environment variables
| Variable | Source | Required | Purpose |
|----------|--------|----------|---------|
[from infra-analyst — names only, never values]

### Infrastructure as Code
[Describe IaC setup: terraform, helm, k8s manifests, CDK, or note its absence]

### Infrastructure concerns
[List from infra-analyst: missing health checks, no caching, secrets in env, etc.]

---

## 8. Coding Conventions

> These are observed conventions from the actual codebase. AI must follow them
> when generating new code, even if they differ from framework defaults.

### Naming
- Variables/functions: [camelCase/snake_case]
- Classes: [PascalCase]
- Files: [kebab-case/camelCase — be specific per file type]
- Database: [naming pattern]
- Constants: [UPPER_SNAKE_CASE/etc.]
- Event names: [pattern if applicable]

### File organisation
[Where does a new feature put its files? Be specific:
"A new domain goes in src/<domain>/ with index.ts, <domain>.service.ts,
<domain>.repository.ts, <domain>.controller.ts, and __tests__/"]

### Error handling
[Describe the established pattern: custom error class? HTTP exception layer?
Result type? Where are errors caught, where are they thrown?]

### Async pattern
[async/await throughout / promise chains in legacy areas / etc. — be honest about inconsistency]

### Logging
[Library, log levels, what gets logged and where]

### Change-safe extension pattern
[Describe the safest way to add a new feature in this codebase without breaking existing
structure. Make this concrete enough that downstream task and implementation agents can follow it.]

---

## 9. Test Strategy

**Framework:** [Jest/Vitest/pytest/JUnit]
**Location:** [co-located __tests__ / separate test/ dir]
**Required types:** [unit + integration / e2e optional]
**Mocking approach:** [jest.mock / manual mocks / factory pattern]
**Coverage tooling:** [istanbul/nyc/coverage-v8/etc.]

### Test naming convention
[describe the pattern: "should <verb> when <condition>"]

### Non-negotiable test requirements
[List what MUST be tested for every new feature — derived from observed patterns]

### Downstream testing expectations
[Spell out what spec/design/tasks/dev/QA agents should assume:
minimum test depth, regression expectations, integration risks, and review triggers.]

---

## 10. AI Generation Rules

> These rules are derived from actual codebase analysis. They are not aspirational —
> they reflect what the codebase actually does. Follow them for consistent output.

### DO
[10-15 specific, file-referenced DOs]
Examples format:
- DO use `AppError` from `src/common/errors.ts` for all business logic errors
- DO add request validation schemas to `src/schemas/<domain>.schema.ts` using zod
- DO use the `BaseRepository<T>` class from `src/common/repository.ts` for DB access

### DO NOT
[10-15 specific, file-referenced DO NOTs]
Examples format:
- DO NOT query the database from controllers — route through service → repository
- DO NOT use `any` type — use `unknown` with type guards or explicit interfaces
- DO NOT hardcode environment values — use `config` from `src/config/index.ts`

### New feature generation checklist
[Step-by-step, specific to THIS project's actual structure]

### Spec vs design note
- Use the constitution to understand the existing system and its constraints
- Let the spec define WHAT should change
- Let the design define HOW the change fits within the constraints captured here

---

## 11. Technical Debt Register

> Review this before starting AI-assisted work in affected areas. AI generation
> will propagate and compound existing debt unless explicitly countered.

| ID | Domain | Location | Issue | Severity | AI Risk | Recommended action |
|----|--------|----------|-------|----------|---------|-------------------|
[from all reports, sorted by severity × AI Risk]

**AI Risk levels:**
- **HIGH** — AI will almost certainly reproduce or worsen this if not explicitly instructed
- **MEDIUM** — AI may reproduce this; include counter-instructions when working in this area
- **LOW** — Cosmetic or structural issue; AI unlikely to interact with it

---

## 12. Sensitive Zones

> AI generation requires explicit human review before merging changes in these areas.

[List files/directories that are: security-critical, known to be fragile,
contain implicit contracts not visible from code, or flagged by the auditor]

For each zone: path + reason + what to watch for

---

## 13. Analysis Metadata & Known Unknowns

**Scan date:** [date]
**Cursor version:** [version]
**Agents run:** domain-scanner ×[N], + 7 specialist agents
**Files sampled:** ~[count]
**Domains covered:** [count]

**Confidence by section:**
| Section | Confidence | Notes |
|---------|------------|-------|
[one row per major section from audit report]

### Known unknowns and open questions
[List what this analysis did NOT cover, what remains inferred, and what needs human follow-up.
Be explicit so downstream agents know where not to over-trust the constitution.]

**Suggested re-analysis triggers:**
- Major ORM migration added
- New API versioning layer introduced
- Auth strategy changed
- New domain directory added at top level
- Quarterly refresh regardless
````

## JSON Schema Template

Write `docs/ai/constitution.json` — a machine-readable structured version of the
constitution for downstream agents that need precise lookups instead of parsing Markdown.

This is a **curated public contract**, not a raw dump of `_merged.json`. Include only
the data downstream agents need, in a stable schema they can depend on.

### Generation instructions

1. Read `.cursor/constitution-tmp/_merged.json` (same source as other outputs)
2. Transform into the schema below, applying the same audit/confidence data
3. Write to `docs/ai/constitution.json`

### Schema

```json
{
  "$schema": "constitution-v1",
  "baseline_date": "YYYY-MM-DD",
  "project": {
    "name": "<from merged>",
    "type": "<Web app|API|Mobile backend|Monorepo|Library>",
    "language": "<primary language>",
    "runtime": { "name": "<node|python|jvm|...>", "version": "<exact version>" },
    "framework": { "name": "<name>", "version": "<exact version>" },
    "package_manager": "<npm|yarn|pnpm|pip|...>",
    "module_format": "<ESM|CommonJS|mixed>",
    "monorepo_tool": "<nx|turborepo|lerna|none>"
  },
  "architecture": {
    "style": "<Clean Architecture|Layered MVC|Hexagonal|Microservices|...>",
    "layers": ["<layer1>", "<layer2>"],
    "domains": [
      { "name": "<label>", "path": "<relative path>", "responsibility": "<1 line>" }
    ],
    "cross_domain_communication": "<direct import|events|REST|...>"
  },
  "tech_stack": [
    { "name": "<package>", "version": "<version>", "role": "<UI|API|DB|testing|infra|util>", "notes": "<generation notes>" }
  ],
  "design_patterns": [
    { "pattern": "<name>", "description": "<how it's used>", "consistency": "high|medium|low" }
  ],
  "file_structure": {
    "new_feature_template": "<path pattern, e.g. src/api/<domain>.ts>",
    "directories": {
      "<purpose>": "<path>"
    }
  },
  "naming": {
    "files": "<pattern>",
    "variables": "<pattern>",
    "classes": "<pattern>",
    "constants": "<pattern>",
    "hooks": "<pattern or null>",
    "database": "<pattern>"
  },
  "code_rules": {
    "error_handling": "<pattern description>",
    "async_pattern": "<async/await|promises|callbacks|mixed>",
    "import_style": "<ESM|CommonJS|mixed>",
    "state_management": "<description or null>"
  },
  "testing": {
    "framework": "<Jest|Vitest|pytest|JUnit|...>",
    "location": "<co-located __tests__|separate test/ dir>",
    "mocking": "<approach>",
    "coverage_target": "<description>",
    "required_types": ["unit", "integration"]
  },
  "rules": {
    "do": [
      "<rule 1 — file-referenced, actionable>"
    ],
    "do_not": [
      "<rule 1 — file-referenced, actionable>"
    ]
  },
  "data_model": {
    "database_type": "<postgres|mysql|mongo|sqlite|mixed>",
    "orm": { "name": "<name>", "version": "<version>" },
    "entities": [
      { "name": "<EntityName>", "table": "<table_name>", "key_relations": "<description>" }
    ]
  },
  "api": {
    "style": "<REST|GraphQL|gRPC|mixed>",
    "auth_strategy": "<JWT Bearer|API key|session|...>",
    "versioning": "<URL prefix /v1|header|none>",
    "base_url_pattern": "<pattern>"
  },
  "sensitive_zones": [
    { "path": "<file or dir>", "reason": "<why>", "review_required": true }
  ],
  "confidence": {
    "overall": "high|medium|low",
    "sections": {
      "<section_name>": { "level": "high|medium|low", "needs_review": false }
    }
  }
}
```

### JSON rules

- Schema version (`$schema: "constitution-v1"`) MUST be present — downstream agents use it for compatibility checks
- All top-level keys are guaranteed present (same contract principle as CONSTITUTION.md sections)
- Arrays may be empty `[]` but must not be omitted
- `null` is allowed for optional scalar fields (e.g., `hooks` naming pattern if not applicable)
- Do NOT include raw evidence files, audit details, or coverage notes — those live in the full analysis
- Do NOT include the full endpoint inventory or entity field details — keep this as a lookup index, not a dump

---

## Viewer Template

Generate `docs/ai/constitution-viewer.html` — a single self-contained HTML file that
renders the **full analysis** as an interactive browsable UI. The viewer is fed from
the full analysis data (not the compact CONSTITUTION).

### Generation instructions

1. Read `.cursor/constitution-tmp/_merged.json` (same data source as the full analysis)
2. Transform the merged data into the `CONSTITUTION_DATA` JSON structure
3. Embed the JSON and the rendering code into a single HTML file
4. Write to `docs/ai/constitution-viewer.html`

### Section IDs and icons

| ID | Title | Icon |
|----|-------|------|
| identity | Project Identity | ◆ |
| architecture | Architecture Overview | ◇ |
| techstack | Tech Stack Contract | ⬡ |
| datamodel | Data Model | ◈ |
| api | API Contract | ↔ |
| runtime | Runtime Behaviour | ⟳ |
| infra | Infrastructure & Deployment | ⛭ |
| conventions | Coding Conventions | § |
| testing | Test Strategy | ✓ |
| rules | AI Generation Rules | ⚡ |
| debt | Technical Debt | ⚠ |
| sensitive | Sensitive Zones | 🔒 |
| metadata | Analysis Metadata | ℹ |

### Visual design requirements

The viewer must have:

1. **Dark sidebar** (left, 280px) with:
   - Project name and metadata header
   - Search input that filters sections by title and content
   - Navigation list with icons, section titles, and active state highlighting
   - Footer with scan metadata

2. **Content area** (right, scrollable) with:
   - Section title with icon
   - Tables for structured data (entities, dependencies, endpoints, debt)
   - Color-coded badges for HTTP methods, confidence levels, severity levels
   - Warning banners for [NEEDS REVIEW] sections
   - Split-column layout for DO/DO NOT rules
   - File template rendered as dark code block
   - Red-bordered cards for sensitive zones

3. **Typography:** IBM Plex Sans for body, IBM Plex Mono for code/paths (Google Fonts CDN)
4. **Color scheme:** Slate palette. Sidebar: slate-900. Content: slate-50.

### Viewer rules

- Fully self-contained — no external JS, no fetch calls, no build step
- All CSS inline in `<style>` tag (Google Fonts CDN is the only external resource)
- Works when opened via `file://` protocol
- Clicking a section in the sidebar renders that section
- Search filters sections in real-time
- Read-only — no editing capability
- Target file size: under 50KB
