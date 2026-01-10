#!/bin/bash
# Claude Code Optimizer - Installation Script
# Installs skill and agents to appropriate locations

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SKILL_DIR="$SCRIPT_DIR/.."

echo "Claude Code Optimizer Installer"
echo "================================"
echo ""

# Check Claude Code version
if command -v claude &> /dev/null; then
    VERSION=$(claude --version 2>/dev/null | head -1)
    echo "✓ Claude Code found: $VERSION"
else
    echo "✗ Claude Code not found. Please install Claude Code first."
    echo "  npm install -g @anthropic-ai/claude-code"
    exit 1
fi

# Parse options
SCOPE="user"
while [[ $# -gt 0 ]]; do
    case $1 in
        --project)
            SCOPE="project"
            shift
            ;;
        --help)
            echo "Usage: install.sh [--project]"
            echo ""
            echo "Options:"
            echo "  --project  Install to current project (.claude/) instead of user (~/.claude/)"
            exit 0
            ;;
        *)
            echo "Unknown option: $1"
            exit 1
            ;;
    esac
done

if [ "$SCOPE" = "project" ]; then
    SKILLS_TARGET=".claude/skills"
    AGENTS_TARGET=".claude/agents"
    echo "Installing to project scope..."
else
    SKILLS_TARGET="$HOME/.claude/skills"
    AGENTS_TARGET="$HOME/.claude/agents"
    echo "Installing to user scope..."
fi

# Create directories
mkdir -p "$SKILLS_TARGET/claude-code-optimizer"
mkdir -p "$AGENTS_TARGET"

# Copy skill
echo "Installing skill..."
cp -r "$SKILL_DIR/SKILL.md" "$SKILLS_TARGET/claude-code-optimizer/"
cp -r "$SKILL_DIR/references" "$SKILLS_TARGET/claude-code-optimizer/"

# Copy agents
echo "Installing agents..."
cp "$SKILL_DIR/agents/"*.md "$AGENTS_TARGET/"

echo ""
echo "✓ Installation complete!"
echo ""
echo "Installed to:"
echo "  Skill:  $SKILLS_TARGET/claude-code-optimizer/"
echo "  Agents: $AGENTS_TARGET/"
echo ""
echo "Usage:"
echo "  In Claude Code, the skill will trigger when you ask about"
echo "  auditing or optimizing your Claude Code setup."
echo ""
echo "  Or invoke directly: 'Run a full Claude Code audit'"
