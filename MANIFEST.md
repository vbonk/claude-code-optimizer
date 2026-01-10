# Claude Code Optimizer

**Version**: 1.1.0  
**Minimum Claude Code**: 2.1.0  
**Authors**: Anthony Velte & Claude Opus 4.5  
**Date**: January 9, 2026

## Package Contents

```
claude-code-optimizer/
├── SKILL.md                    # Main skill (install to skills/)
├── references/
│   ├── config-guide.md         # Configuration audit details
│   ├── hooks-guide.md          # Hooks audit details
│   ├── permissions-guide.md    # Permissions audit details
│   └── troubleshooting.md      # Common issues and fixes
├── agents/
│   ├── audit-orchestrator.md   # Coordinates full audits
│   ├── config-auditor.md       # Configuration specialist
│   ├── hooks-auditor.md        # Hooks specialist
│   ├── permissions-auditor.md  # Permissions specialist
│   └── workflow-auditor.md     # Commands/agents/skills specialist
└── scripts/
    └── install.sh              # Installation helper
```

## Installation

### Automatic (recommended)
```bash
cd claude-code-optimizer
./scripts/install.sh           # User scope
./scripts/install.sh --project # Project scope
```

### Manual
```bash
# User scope
cp -r claude-code-optimizer ~/.claude/skills/
cp agents/*.md ~/.claude/agents/

# Project scope
cp -r claude-code-optimizer .claude/skills/
cp agents/*.md .claude/agents/
```

## Usage

The skill triggers automatically when you mention:
- "audit my Claude Code setup"
- "check my Claude Code configuration"
- "optimize my Claude Code"

Or invoke directly:
- "Run a full Claude Code audit"
- "Check my hooks configuration"
- "Audit my permissions"

## Verification

After installation, verify:
```bash
claude --version  # Should be 2.1.0+
```

In Claude Code:
```
What skills are available?
```

You should see `claude-code-optimizer` listed.
