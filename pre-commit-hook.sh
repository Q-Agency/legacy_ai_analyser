#!/usr/bin/env bash
# .git/hooks/pre-commit — constitution drift check
# Copy this file to your project's .git/hooks/pre-commit and chmod +x it.

set -euo pipefail

CONSTITUTION="docs/ai/constitution.md"
STRICT_MODE="${CONSTITUTION_STRICT:-0}"
DRIFT_PATTERNS=(
  'schema\.prisma$'
  'migrations/.*\.sql$'
  'openapi\.(yaml|yml|json)$'
  'swagger\.(yaml|yml|json)$'
  'routes/.*\.(ts|tsx|js|jsx)$'
  'controllers/.*\.(ts|tsx|js|jsx)$'
  'middleware/.*\.(ts|tsx|js|jsx)$'
  'Dockerfile'
  'docker-compose.*\.(yaml|yml)$'
  '\.github/workflows/.*\.(yaml|yml)$'
  '\.gitlab-ci\.yml$'
  'Jenkinsfile$'
  '.*\.tf$'
  'serverless\.(yaml|yml)$'
  'fly\.toml$'
  'vercel\.json$'
  'netlify\.toml$'
)
REQUIRED_ARTIFACTS=(
  "docs/ai/constitution.md"
  "docs/ai/constitution-cheatsheet.md"
  "docs/ai/constitution-viewer.html"
)

if [ ! -f "$CONSTITUTION" ]; then
  echo "WARN: No constitution found. Run /constitution to generate docs/ai/constitution.md"
  exit 0
fi

missing_artifacts=0
for artifact in "${REQUIRED_ARTIFACTS[@]}"; do
  if [ ! -f "$artifact" ]; then
    echo "WARN: Missing constitution artifact: $artifact"
    missing_artifacts=1
  fi
done

if [ "$missing_artifacts" -eq 1 ] && [ "$STRICT_MODE" = "1" ]; then
  echo "ERROR: Required constitution artifacts are missing (strict mode enabled)."
  exit 1
fi

staged_files="$(git diff --cached --name-only)"
drift_detected=0

for pattern in "${DRIFT_PATTERNS[@]}"; do
  changed="$(printf '%s\n' "$staged_files" | grep -E "$pattern" || true)"
  if [ -n "$changed" ]; then
    echo "WARN: Constitution drift detected in:"
    printf '%s\n' "$changed"
    echo "      Consider updating docs/ai/constitution.md"
    drift_detected=1
  fi
done

if [ "$drift_detected" -eq 1 ] && [ "$STRICT_MODE" = "1" ]; then
  echo "ERROR: Constitution drift detected (strict mode enabled)."
  exit 1
fi
