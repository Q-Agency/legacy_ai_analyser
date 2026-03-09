---
name: constitution-aggregator
description: >
  Merges all partial JSON and MD reports from .cursor/constitution-tmp/ into a
  single coherent intermediate representation, applying audit findings to flag
  uncertain content. Invoke after auditor completes.
version: 2.1.0
---

# Constitution Aggregator

## Purpose

Merge all scan reports into one verified intermediate structure (`_merged.json`)
that the curator uses to produce all four outputs: `full-analysis-YYYY-MM-DD.md`,
`CONSTITUTION.md`, `constitution.json`, and `constitution-viewer.html`.

The `_merged.json` schema defined below is the **single contract** between the
aggregator and all downstream consumers. Follow it exactly.

## Steps

1. List all files: `ls -la .cursor/constitution-tmp/`
   Skip `_status-*.json`, `_pipeline.json`, and `_merged.json` (if present from a previous run).

2. Read the audit report FIRST: `.cursor/constitution-tmp/audit-report.json`
   This tells you which claims to accept, flag, or exclude.

2.5. Read `_corrections.json` if it exists (check both `.cursor/constitution-tmp/_corrections.json`
   and `docs/ai/constitution-corrections.json` as fallback). For each correction:
   - Find the matching claim in the agent reports by section and original_claim text
   - Override that claim with the corrected_claim value
   - If original_claim no longer matches any agent report content, flag it as a stale
     correction in the merged output under `"stale_corrections": [...]`
   - Report stale correction count to the user so they can review

2.7. Read `_human-answers.json` if it exists. For each answer:
   - Find the matching section in the agent reports
   - Override or supplement the automated claim with the human-provided answer
   - Mark the answer source as `"human"` so the curator can attribute it
   - For skipped questions: note the gap as `[UNRESOLVED]` in the merged structure
     (distinct from `[NEEDS REVIEW]` — the human was asked and chose not to answer)
   - If `free_form` is non-null: parse the user's open input for rules, constraints, or
     context. Route each item to the most relevant section in the merged structure
     (e.g., naming rules → `coding_conventions`, auth notes → `cross_domain_concerns`,
     deployment constraints → `infrastructure`). Mark each as `"source": "human"`.

3. Read all other JSON report files in this order:
   - dependencies.json (tech stack — sets the frame)
   - patterns.json (architecture — shapes everything else)
   - data-model.json
   - api-contracts.json
   - runtime-flow.json
   - infra.json (infrastructure and deployment — if present)
   - domain-*.json (all domain scanner outputs — if a domain report has a `packages`
     array, unpack each package as a separate domain entry in the merged structure)

4. Build the merged structure following the **`_merged.json` schema** below exactly.
   Populate each section from the corresponding agent report(s) as noted in the
   `"_source"` comments. Cross-check data between reports where indicated.

5. For every section, populate the `_meta` block with grounded evidence from agent
   reports, audit findings, and `files_read_list` — not generic filler text.

6. For every item marked in `sections_to_flag_in_constitution` in the audit report:
   set `"confidence": "low"` and `"needs_human_review": true` in that section's `_meta`,
   while preserving the `evidence_files` and `unresolved_gaps` that explain why.

7. Write merged output to `.cursor/constitution-tmp/_merged.json`

8. Report: "Aggregation complete: <domain count> domains, <endpoint count> endpoints,
   <issue count> debt items, <flagged count> sections flagged for review."

---

## `_merged.json` Schema

This is the **single contract** between the aggregator and all downstream consumers
(curator, viewer, `constitution.json`). Every key listed below MUST be present in the
output. Arrays may be empty `[]` but must not be omitted. Nullable scalars are marked.

```json
{
  "generated_at": "<ISO 8601 timestamp>",
  "overall_confidence": "high|medium|low",
  "stale_corrections": [],

  "system_identity": {
    "_source": "dependencies.json + domain-*.json + patterns.json",
    "_meta": {
      "confidence": "high|medium|low",
      "confidence_reason": "<why>",
      "evidence_files": ["<path>"],
      "unresolved_gaps": ["<gap>"],
      "needs_human_review": false,
      "downstream_use": "All agents: orient on what this project is"
    },
    "name": "<project name from package.json or inferred>",
    "type": "<Web app|API|Mobile backend|Monorepo|Library>",
    "description": "<2-3 sentences: what it does, who uses it>",
    "primary_language": "<language(s) with approx % split>",
    "runtime": { "name": "<node|python|jvm|...>", "version": "<exact version>" },
    "framework": { "name": "<name>", "version": "<exact version>" },
    "package_manager": "<npm|yarn|pnpm|pip|...>",
    "module_format": "<ESM|CommonJS|mixed>",
    "monorepo_tool": "<nx|turborepo|lerna|none|null>"
  },

  "architecture": {
    "_source": "patterns.json + domain-*.json",
    "_meta": { "confidence": "", "confidence_reason": "", "evidence_files": [], "unresolved_gaps": [], "needs_human_review": false, "downstream_use": "Design/task agents: understand boundaries" },
    "style": "<Clean Architecture|Layered MVC|Hexagonal|Microservices|...>",
    "layers": [
      { "name": "<layer name>", "description": "<one line>" }
    ],
    "domains": [
      {
        "name": "<label>",
        "path": "<relative path>",
        "responsibility": "<1-2 sentences>",
        "key_modules": ["<file path>"],
        "internal_dependencies": ["<other domain path>"],
        "confidence": "high|medium|low"
      }
    ],
    "cross_domain_communication": "<direct import|events|REST|...>",
    "domain_boundaries": "<description of seams, ownership, shared abstractions>",
    "directory_map": "<key directory tree with annotations>"
  },

  "tech_stack": {
    "_source": "dependencies.json",
    "_meta": { "confidence": "", "confidence_reason": "", "evidence_files": [], "unresolved_gaps": [], "needs_human_review": false, "downstream_use": "All agents: never introduce unlisted deps" },
    "runtime": { "name": "", "version": "" },
    "framework": { "name": "", "version": "" },
    "package_manager": "",
    "monorepo_tool": "<name|null>",
    "build_tools": ["<name>"],
    "key_dependencies": [
      { "name": "", "version": "", "role": "<UI|API|DB|testing|infra|util>", "notes": "<generation notes or null>" }
    ],
    "hard_constraints": [
      "<constraint description, e.g. 'Node 20.x — enforce via .nvmrc'>"
    ]
  },

  "data_model": {
    "_source": "data-model.json, cross-checked against domain-*.json",
    "_meta": { "confidence": "", "confidence_reason": "", "evidence_files": [], "unresolved_gaps": [], "needs_human_review": false, "downstream_use": "Design agents: schema changes, new entities" },
    "database_type": "<postgres|mysql|mongo|sqlite|mixed>",
    "orm": { "name": "", "version": "" },
    "schema_location": "<path>",
    "entities": [
      {
        "name": "<EntityName>",
        "table": "<table_name>",
        "file": "<path>",
        "fields": [
          { "name": "", "type": "", "nullable": false, "indexed": false }
        ],
        "relations": [
          { "type": "OneToMany|ManyToOne|ManyToMany", "target": "<EntityName>" }
        ]
      }
    ],
    "data_flow_pattern": "<description of request → controller → service → repo → DB path>",
    "data_invariants": ["<what must always remain true>"],
    "naming_conventions": {
      "tables": "<pattern>",
      "columns": "<pattern>",
      "ids": "<UUID|auto-increment|ULID + where generated>"
    },
    "issues": [
      { "description": "", "severity": "high|medium|low" }
    ]
  },

  "api_surface": {
    "_source": "api-contracts.json, cross-checked against runtime-flow.json",
    "_meta": { "confidence": "", "confidence_reason": "", "evidence_files": [], "unresolved_gaps": [], "needs_human_review": false, "downstream_use": "Spec/design agents: new/modified endpoints" },
    "style": "<REST|GraphQL|gRPC|mixed>",
    "auth_strategy": "<JWT Bearer|API key|session|OAuth2|...>",
    "versioning": "<URL prefix /v1|header|none>",
    "base_url_pattern": "<pattern>",
    "surfaces": [
      {
        "type": "REST|GraphQL|gRPC|Event|Internal",
        "file": "<path>",
        "endpoints": [
          { "method": "GET|POST|PUT|PATCH|DELETE", "path": "<path>", "auth": "<none|jwt|apikey|...>", "description": "" }
        ]
      }
    ],
    "request_response_conventions": {
      "content_type": "<value>",
      "error_format": "<description of standard error shape>",
      "pagination": "<pattern>",
      "date_format": "<ISO 8601|Unix timestamp|...>"
    },
    "integration_points": ["<external/internal contract boundaries>"],
    "gaps_and_inconsistencies": ["<observation>"]
  },

  "runtime_behaviour": {
    "_source": "runtime-flow.json",
    "_meta": { "confidence": "", "confidence_reason": "", "evidence_files": [], "unresolved_gaps": [], "needs_human_review": false, "downstream_use": "Implementation agents: middleware, side effects, implicit contracts" },
    "entry_points": [
      { "type": "HTTP|CLI|Job|Event", "file": "<path>", "description": "" }
    ],
    "middleware_chain": [
      { "name": "", "file": "<path>", "fires_on": "<description>", "purpose": "" }
    ],
    "traced_flows": [
      {
        "name": "<flow name>",
        "entry": "<path>",
        "layers": ["<file> → <what it does>"],
        "side_effects": {
          "db_writes": ["<table>"],
          "events_emitted": ["<event name>"],
          "external_calls": ["<service>"],
          "cache_invalidated": ["<key pattern>"]
        },
        "implicit_preconditions": ["<thing that must be true>"]
      }
    ],
    "global_side_effects": ["<things that always happen regardless of endpoint>"],
    "operational_invariants": ["<middleware ordering, auth rules, implicit runtime assumptions>"]
  },

  "infrastructure": {
    "_source": "infra.json (if present — may be empty for projects without infra config)",
    "_meta": { "confidence": "", "confidence_reason": "", "evidence_files": [], "unresolved_gaps": [], "needs_human_review": false, "downstream_use": "Task agents: CI/CD, Docker, deployment constraints" },
    "deployment_targets": [
      { "target": "", "platform": "", "strategy": "", "config_file": "" }
    ],
    "ci_cd_pipelines": [
      { "pipeline": "", "platform": "", "triggers": "", "stages": "" }
    ],
    "containerisation": {
      "dockerfiles": ["<path>"],
      "base_images": ["<image>"],
      "multi_stage": false,
      "compose_files": ["<path or empty>"]
    },
    "deployment_topology": "<description of how components connect in production>",
    "env_variables": [
      { "name": "", "source": "", "required": true, "purpose": "" }
    ],
    "iac": "<description of terraform/helm/k8s/CDK setup or 'none'>",
    "operational_constraints": ["<deployment/runtime/build assumptions>"],
    "concerns": ["<missing health checks, secrets in env, etc.>"]
  },

  "coding_conventions": {
    "_source": "patterns.json + domain-*.json",
    "_meta": { "confidence": "", "confidence_reason": "", "evidence_files": [], "unresolved_gaps": [], "needs_human_review": false, "downstream_use": "Implementation agents: naming, error handling, async, file org" },
    "naming": {
      "variables_functions": "<camelCase|snake_case>",
      "classes": "<PascalCase>",
      "files": "<kebab-case|camelCase — per file type>",
      "database": "<pattern>",
      "constants": "<UPPER_SNAKE_CASE|...>",
      "events": "<pattern or null>",
      "hooks": "<pattern or null>"
    },
    "file_organisation": "<where a new feature puts its files — be specific>",
    "error_handling": "<custom error class? HTTP exception layer? Result type?>",
    "async_pattern": "<async/await|promises|callbacks|mixed>",
    "logging": "<library, log levels, what gets logged>",
    "change_safe_extension_pattern": "<safest way to add a new feature without breaking existing structure>"
  },

  "test_strategy": {
    "_source": "patterns.json",
    "_meta": { "confidence": "", "confidence_reason": "", "evidence_files": [], "unresolved_gaps": [], "needs_human_review": false, "downstream_use": "QA/implementation agents: write correct tests" },
    "framework": "<Jest|Vitest|pytest|JUnit|...>",
    "location": "<co-located __tests__|separate test/ dir>",
    "required_types": ["unit", "integration"],
    "mocking_approach": "<jest.mock|manual mocks|factory pattern>",
    "coverage_tooling": "<istanbul|nyc|coverage-v8|...>",
    "naming_convention": "<describe pattern>",
    "non_negotiable_requirements": ["<what MUST be tested for every new feature>"],
    "gaps": ["<known test coverage gaps>"]
  },

  "ai_generation_rules": {
    "_source": "patterns.json + all agent reports (derived)",
    "_meta": { "confidence": "", "confidence_reason": "", "evidence_files": [], "unresolved_gaps": [], "needs_human_review": false, "downstream_use": "All agents: primary DO/DO NOT constraints" },
    "do": [
      "<file-referenced, actionable rule>"
    ],
    "do_not": [
      "<file-referenced, actionable rule — includes HIGH AI-risk debt items and sensitive zone warnings>"
    ],
    "new_feature_checklist": [
      "<step-by-step, specific to THIS project>"
    ]
  },

  "design_patterns": {
    "_source": "patterns.json",
    "_meta": { "confidence": "", "confidence_reason": "", "evidence_files": [], "unresolved_gaps": [], "needs_human_review": false, "downstream_use": "Implementation agents: follow, don't invent" },
    "architectural_style": "<description>",
    "patterns": [
      { "pattern": "<name>", "locations": ["<file>"], "description": "<how it's used>", "consistency": "high|medium|low" }
    ],
    "anti_patterns": [
      { "pattern": "<name>", "locations": ["<file>"], "severity": "high|medium|low" }
    ]
  },

  "technical_debt": {
    "_source": "all agent reports, deduplicated, sorted by severity × AI risk",
    "_meta": { "confidence": "", "confidence_reason": "", "evidence_files": [], "unresolved_gaps": [], "needs_human_review": false, "downstream_use": "All agents: avoid propagating/compounding debt" },
    "items": [
      {
        "id": "debt-<NNN>",
        "domain": "<domain name>",
        "location": "<file or dir>",
        "issue": "<description>",
        "severity": "high|medium|low",
        "ai_risk": "HIGH|MEDIUM|LOW",
        "recommended_action": "<what to do>"
      }
    ]
  },

  "sensitive_zones": {
    "_source": "constitution-auditor.md + all agent reports",
    "_meta": { "confidence": "", "confidence_reason": "", "evidence_files": [], "unresolved_gaps": [], "needs_human_review": false, "downstream_use": "All agents: require human review before touching" },
    "zones": [
      {
        "path": "<file or dir>",
        "reason": "<why it's sensitive>",
        "watch_for": "<what to watch for when modifying>"
      }
    ]
  },

  "cross_domain_concerns": {
    "_source": "patterns.json + runtime-flow.json + api-contracts.json",
    "_meta": { "confidence": "", "confidence_reason": "", "evidence_files": [], "unresolved_gaps": [], "needs_human_review": false, "downstream_use": "Design agents: shared concerns that cut across domains" },
    "auth": "<description of auth approach across the system>",
    "error_handling": "<description of cross-domain error strategy>",
    "logging": "<description of logging approach>",
    "events": "<description of event/message patterns or null>"
  },

  "audit_summary": {
    "_source": "audit-report.json",
    "overall_confidence": "high|medium|low",
    "verified_claim_count": 0,
    "contested_claim_count": 0,
    "unverified_claim_count": 0,
    "critical_gaps": ["<something important no report covered>"],
    "sections_flagged_for_review": ["<section_key: reason>"]
  }
}
```

### Schema rules

- Every top-level key MUST be present in the output
- Every `_meta` block MUST be populated with grounded evidence, not placeholders
- `_source` comments are documentation only — do not include them in the actual JSON output
- Arrays may be empty `[]` but must not be omitted
- Nullable scalars (marked `or null`) may be `null`
- The curator, viewer, and `constitution.json` all consume this schema — if you change a key name here, those consumers break
- When a section has no data (e.g., `infrastructure` when no infra files exist), keep the structure intact with empty arrays and a `_meta.confidence` of `"low"` and `_meta.unresolved_gaps` explaining why
