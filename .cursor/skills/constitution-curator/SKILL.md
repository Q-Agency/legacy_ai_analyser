---
name: constitution-curator
description: >
  Reads .cursor/constitution-tmp/_merged.json and writes the final
  docs/ai/constitution.md following the canonical template. Invoke after
  aggregation completes.
version: 2.0.0
---

# Constitution Curator

## Purpose

Write `docs/ai/constitution.md` from the merged, audited intermediate data.
This is the document that all future AI generation work will reference.

## Steps

1. Read `.cursor/constitution-tmp/_merged.json`
2. Also read all `docs/ai/constitution-fragments/*.md` for narrative context
3. Write `docs/ai/constitution.md` following the template below exactly
4. For any section with `needs_human_review: true`: add a visible warning block
5. Report: "Constitution written — <section count> sections, ~<word count> words"

## Template

---

# constitution.md — [Project Name] AI Generation Contract

> **Version:** 1.0
> **Generated:** [date]
> **Method:** Cursor multi-agent analysis (domain-scanner × N, api-contract-analyst,
> data-model-analyst, dependency-analyst, pattern-analyst, runtime-flow-analyst,
> constitution-auditor)
> **Overall confidence:** [from audit report]

---

> ⚠️ **Sections marked [NEEDS REVIEW]** contain claims that the auditor could not
> fully verify or that were contested across multiple reports. Do not treat these
> as authoritative without human validation.

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

### AI generation note
> When adding new endpoints or operations:
> [List specific rules derived from runtime-flow analysis]

---

## 7. Coding Conventions

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

---

## 8. Test Strategy

**Framework:** [Jest/Vitest/pytest/JUnit]
**Location:** [co-located __tests__ / separate test/ dir]
**Required types:** [unit + integration / e2e optional]
**Mocking approach:** [jest.mock / manual mocks / factory pattern]
**Coverage tooling:** [istanbul/nyc/coverage-v8/etc.]

### Test naming convention
[describe the pattern: "should <verb> when <condition>"]

### Non-negotiable test requirements
[List what MUST be tested for every new feature — derived from observed patterns]

---

## 9. AI Generation Rules

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

---

## 10. Technical Debt Register

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

## 11. Sensitive Zones

> AI generation requires explicit human review before merging changes in these areas.

[List files/directories that are: security-critical, known to be fragile,
contain implicit contracts not visible from code, or flagged by the auditor]

For each zone: path + reason + what to watch for

---

## 12. Analysis Metadata

**Scan date:** [date]
**Cursor version:** [version]
**Agents run:** domain-scanner ×[N], + 6 specialist agents
**Files sampled:** ~[count]
**Domains covered:** [count]

**Confidence by section:**
| Section | Confidence | Notes |
|---------|------------|-------|
[one row per major section from audit report]

**Known gaps:**
[List what this analysis did NOT cover — be honest]

**Suggested re-analysis triggers:**
- Major ORM migration added
- New API versioning layer introduced
- Auth strategy changed
- New domain directory added at top level
- Quarterly refresh regardless
