#!/usr/bin/env bash
# install.sh — Install the Constitution Generator into your project
#
# NOTE: This script is for the non-plugin branch. On the main branch,
# use /add-plugin instead (see README.md).
#
# Usage:
#   cd /path/to/your/project
#   bash /path/to/constitution-kit/install.sh
#
# Or copy the constitution-kit folder next to your project and run:
#   bash ../constitution-kit/install.sh

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "=== Cursor Constitution Generator — Installer ==="
echo ""
echo "Installing into: $(pwd)"
echo ""

# 1. Create directory structure
echo "[1/5] Creating directories..."
mkdir -p .cursor/agents
mkdir -p .cursor/skills/constitution
mkdir -p .cursor/skills/constitution-aggregator
mkdir -p .cursor/skills/constitution-curator
mkdir -p .cursor/skills/constitution-patch
mkdir -p .cursor/rules
mkdir -p .cursor/constitution-tmp
mkdir -p docs/ai/constitution-fragments

# 2. Copy .cursorignore (don't overwrite if exists)
echo "[2/5] Setting up .cursorignore..."
if [ -f .cursorignore ]; then
  echo "  ⚠️  .cursorignore already exists — skipping (review it manually)"
else
  cp "$SCRIPT_DIR/.cursorignore" .cursorignore
  echo "  ✓ Created .cursorignore"
fi

# 3. Copy agents
echo "[3/5] Installing subagents..."
cp "$SCRIPT_DIR/.cursor/agents/"*.md .cursor/agents/
echo "  ✓ 8 agents installed"

# 4. Copy skills
echo "[4/5] Installing skills..."
cp "$SCRIPT_DIR/.cursor/skills/constitution/SKILL.md" .cursor/skills/constitution/SKILL.md
cp "$SCRIPT_DIR/.cursor/skills/constitution-aggregator/SKILL.md" .cursor/skills/constitution-aggregator/SKILL.md
cp "$SCRIPT_DIR/.cursor/skills/constitution-curator/SKILL.md" .cursor/skills/constitution-curator/SKILL.md
cp "$SCRIPT_DIR/.cursor/skills/constitution-patch/SKILL.md" .cursor/skills/constitution-patch/SKILL.md
echo "  ✓ 4 skills installed"

# 5. Copy rules
echo "[5/5] Installing rules..."
cp "$SCRIPT_DIR/.cursor/rules/"*.mdc .cursor/rules/
echo "  ✓ 1 rule installed"

# Set up tmp gitignore
echo ""
echo "Finalising..."
echo '*' > .cursor/constitution-tmp/.gitignore
echo '!.gitignore' >> .cursor/constitution-tmp/.gitignore

echo ""
echo "=== Installation complete ==="
echo ""
echo "Files installed:"
echo "  .cursorignore"
echo "  .cursor/agents/           (8 subagent definitions)"
echo "  .cursor/skills/           (4 skill definitions)"
echo "  .cursor/rules/            (1 rule file)"
echo "  .cursor/constitution-tmp/ (scratch space, gitignored)"
echo "  docs/ai/                  (output directory)"
echo ""
echo "Next steps:"
echo "  1. Open this project in Cursor"
echo "  2. Review .cursorignore — adjust for your project's specifics"
echo "  3. In Cursor agent chat, type:"
echo "     /constitution"
echo ""
echo "For monorepos with >10 packages, create .cursor/constitution.config.json"
echo "  to configure concurrency limits and domain grouping strategy."
echo "  See project docs for schema details."
