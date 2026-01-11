# Configuration Audit Guide

## Settings File Locations

### Priority Order (highest to lowest)
1. Project: `.claude/settings.json`
2. User: `~/.claude/settings.json`
3. Managed (Linux): `/etc/claude/settings.json`
4. Managed (Windows): `C:\Program Files\ClaudeCode\managed-settings.json`
   - Note: `C:\ProgramData\ClaudeCode\` path deprecated in 2.1.2

### Memory File Locations
| File | Scope | Git |
|------|-------|-----|
| `CLAUDE.md` (project root) | Project | ✓ Commit |
| `.claude/CLAUDE.md` | Project | ✓ Commit |
| `CLAUDE.local.md` | Project | ✗ Gitignored |
| `~/.claude/CLAUDE.md` | User | N/A |
| `~/.claude/rules/*.md` | User rules | N/A |
| `.claude/rules/*.md` | Project rules | ✓ Commit |

## Settings.json Schema (2.1.3+)

```json
{
  "model": "claude-sonnet-4-5-20250929",
  "theme": "dark",
  "language": "english",
  "respectGitignore": true,
  "releaseChannel": "stable",
  "fileSuggestion": "custom-search-command",
  "env": {
    "CUSTOM_VAR": "value"
  },
  "permissions": {
    "allow": [],
    "deny": []
  },
  "hooks": {},
  "mcpServers": {}
}
```

### New Settings (2.0.65 - 2.1.3)
| Key | Version | Purpose |
|-----|---------|---------|
| `fileSuggestion` | 2.0.65+ | Custom command for `@` file search |
| `releaseChannel` | 2.1.3+ | `stable` or `latest` update channel |

### Environment Variables
| Variable | Purpose |
|----------|---------|
| `CLAUDE_CODE_FILE_READ_MAX_OUTPUT_TOKENS` | Override default file read token limit |
| `CLAUDE_CODE_SHELL` | Override default shell |
| `FORCE_AUTOUPDATE_PLUGINS` | Control plugin auto-update behavior |

## CLAUDE.md Best Practices

### Structure
```markdown
# Project Name

## Overview
Brief project description.

## Architecture
Key technical decisions.

## Conventions
- Coding standards
- File naming
- Commit message format

## Commands
Common operations and how to run them.

## Gotchas
Non-obvious behaviors to remember.
```

### Import Syntax
Reference external files:
```markdown
See @README.md for overview.
Follow @docs/style-guide.md conventions.
```

### Conditional Rules
In `.claude/rules/*.md`:
```yaml
---
paths: src/api/**/*.ts
---
# API Rules
These rules only apply to API files.
```

## Audit Procedure

1. **Check file existence**
   ```bash
   ls -la ~/.claude/settings.json .claude/settings.json CLAUDE.md 2>/dev/null
   ```

2. **Validate JSON syntax**
   ```bash
   cat ~/.claude/settings.json | jq . 2>&1
   ```

3. **Check for deprecated keys**
   - Remove any keys not in official schema
   - Check for old permission formats

4. **Verify CLAUDE.md content**
   - Not too long (causes context bloat)
   - Contains actionable information
   - No sensitive data (API keys, passwords)

5. **Check rules structure**
   ```bash
   find .claude/rules -name "*.md" -exec head -10 {} \;
   ```

## Common Configuration Issues

| Issue | Symptom | Fix |
|-------|---------|-----|
| Invalid JSON | Settings ignored | Validate with `jq` |
| Wrong path | Config not loaded | Check exact paths |
| Too much in CLAUDE.md | Context exhaustion | Split into rules/ |
| Sensitive data exposed | Security risk | Use env vars instead |
