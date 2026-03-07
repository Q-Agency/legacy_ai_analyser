#!/bin/bash
# .git/hooks/pre-commit — constitution drift check
# Copy this file to your project's .git/hooks/pre-commit and chmod +x it.

CONSTITUTION="docs/ai/constitution.md"
DRIFT_FILES="schema.prisma openapi.yaml swagger.json"

if [ ! -f "$CONSTITUTION" ]; then
  echo "⚠️  No constitution found. Run /constitution to generate docs/ai/constitution.md"
  exit 0
fi

CONSTITUTION_DATE=$(git log -1 --format="%ct" -- "$CONSTITUTION" 2>/dev/null || echo 0)

for pattern in $DRIFT_FILES; do
  CHANGED=$(git diff --cached --name-only | grep "$pattern")
  if [ -n "$CHANGED" ]; then
    echo "⚠️  Constitution drift: $CHANGED changed. Consider updating docs/ai/constitution.md"
  fi
done
