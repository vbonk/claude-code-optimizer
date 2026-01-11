# Claude Code Optimizer v1.2.0 Release Notes

**Release Date**: January 11, 2026
**Minimum Claude Code Version**: 2.1.3

---

## Overview

This release brings the Claude Code Optimizer to full feature parity with Claude Code 2.1.3, adds a new MCP auditor, introduces comprehensive security auditing, and includes significant quality-of-life improvements.

---

## What's New

### New Agent: MCP Auditor

A dedicated auditor for MCP (Model Context Protocol) server configurations:
- Scans settings.json and .mcp.json for server configurations
- Detects hardcoded secrets and API keys
- Identifies high-risk server types
- Validates filesystem scope restrictions
- Checks MCP tool permission coverage
- Provides security recommendations per server type

### Security Auditing

New comprehensive security analysis across all auditors:
- **Hooks**: Detects dangerous command patterns (curl, eval, exec, base64)
- **MCP**: Secret detection, high-risk server identification
- **Permissions**: Unreachable rule detection, pattern validation
- **New reference guide**: `references/security-guide.md` with threat model, audit checklist, and incident response procedures

### Context Optimization

New checks to help prevent context exhaustion:
- CLAUDE.md size thresholds (< 200 lines ideal)
- Rules file sizing recommendations
- Bloat detection patterns
- Proactive management tips

### Pattern Validation

Permission patterns are now validated to catch common mistakes:
- Missing `:*` suffix detection
- Glob-style vs regex clarification
- Common mistakes table with fixes
- Pattern testing procedures

### Phase 4 Polish

- **LSP Tool**: Added to tool list and troubleshooting guide
- **Claude in Chrome**: Documentation for browser integration
- **Plugins**: Audit section for plugin management
- **Keyboard Shortcuts**: Reference table for navigation and Vim mode
- **Commands Reference**: Quick reference table for useful slash commands
- **Statistics**: `/stats` command documentation

---

## Breaking Changes

- **Minimum version increased**: Now requires Claude Code 2.1.3+ (was 2.1.0)
- No other breaking changes

---

## Agents (6 total)

| Agent | Purpose |
|-------|---------|
| `audit-orchestrator` | Coordinates comprehensive audits |
| `config-auditor` | Settings.json and CLAUDE.md files |
| `hooks-auditor` | Hook configurations and security |
| `permissions-auditor` | Permission patterns and validation |
| `workflow-auditor` | Commands, agents, skills, plugins |
| `mcp-auditor` | **NEW** - MCP server configurations |

---

## Reference Guides (5 total)

| Guide | Key Additions |
|-------|---------------|
| `config-guide.md` | Context optimization, new settings keys |
| `hooks-guide.md` | `once: true`, `agent_type`, SessionStart input |
| `permissions-guide.md` | Pattern validation, unreachable rules |
| `security-guide.md` | **NEW** - Threat model, incident response |
| `troubleshooting.md` | LSP, Chrome, shortcuts, /stats |

---

## Claude Code 2.1.3 Features Covered

| Feature | Version | Covered |
|---------|---------|---------|
| Unreachable permission rule detection | 2.1.3 | ✓ |
| Release channel configuration | 2.1.3 | ✓ |
| Merged skills/commands model | 2.1.3 | ✓ |
| `agent_type` in SessionStart | 2.1.2 | ✓ |
| `once: true` hook option | 2.1.0 | ✓ |
| `context: fork` frontmatter | 2.1.0 | ✓ |
| `agent` field in skills | 2.1.0 | ✓ |
| MCP wildcard permissions | 2.0.70 | ✓ |
| Named sessions | 2.0.64 | ✓ |
| LSP integration | 2.0.74 | ✓ |
| Claude in Chrome | 2.0.72 | ✓ |

---

## Installation

```bash
git clone https://github.com/vbonk/claude-code-optimizer.git
cd claude-code-optimizer
./scripts/install.sh
```

Or for project-scoped installation:
```bash
./scripts/install.sh --project
```

---

## Usage

```
# Full audit
Audit my Claude Code setup

# Targeted audits
Check my Claude Code configuration
Audit my hooks
Review my permissions setup
Audit my MCP servers
Run a security audit
```

---

## QA Verification

This release has passed comprehensive QA:
- ✅ All 6 agents have valid frontmatter
- ✅ All 5 reference guides complete
- ✅ SKILL.md is 118 lines (< 500 limit)
- ✅ All tool names verified
- ✅ All hook events verified
- ✅ Version references updated to 2.1.3

---

## Contributors

- Anthony Velte (@vbonk)
- Claude Opus 4.5

---

## License

MIT License
