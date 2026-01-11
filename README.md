<div align="center">

# Claude Code Optimizer

**Audit and optimize your Claude Code installation to current best practices**

[![Claude Code 2.1.3+](https://img.shields.io/badge/Claude%20Code-2.1.3%2B-blue?style=flat-square&logo=anthropic)](https://code.claude.com)
[![Version](https://img.shields.io/badge/version-1.2.0-green?style=flat-square)](https://github.com/vbonk/claude-code-optimizer/releases)
[![License](https://img.shields.io/badge/license-MIT-purple?style=flat-square)](LICENSE)
[![Validation](https://img.shields.io/badge/checks-34%2F34%20passed-brightgreen?style=flat-square)](#validation)

[Features](#features) • [Installation](#installation) • [Usage](#usage) • [Architecture](#architecture) • [Documentation](#documentation)

</div>

---

## Why This Exists

Claude Code is evolving rapidly—2.1.0 alone shipped with 1,096 commits. Configuration options are scattered across multiple files, best practices aren't always obvious, and it's easy to miss features that could dramatically improve your workflow.

**Claude Code Optimizer** is a skill that audits your setup, identifies issues, and guides you to an optimized configuration.

## Features

- **🔍 Comprehensive Auditing** — Analyzes settings, hooks, permissions, MCP servers, commands, agents, and skills
- **🎯 Six Specialized Agents** — Focused auditors for config, hooks, permissions, MCP, workflows, plus orchestrator
- **🔒 Security Analysis** — Detects hardcoded secrets, dangerous patterns, data exfiltration risks
- **📊 Context Optimization** — Identifies bloated configs causing context exhaustion
- **✅ Pattern Validation** — Catches permission patterns that won't match as expected
- **📋 Actionable Reports** — Every finding includes severity, impact, and specific fix instructions
- **📚 Built-in References** — Five detailed guides including security audit procedures
- **⚡ Current** — Targets Claude Code 2.1.3+ with all 12 hook events and latest settings schema

## Installation

### Quick Install (Recommended)

```bash
# Clone the repository
git clone https://github.com/vbonk/claude-code-optimizer.git
cd claude-code-optimizer

# Run the installer
./scripts/install.sh
```

### Manual Install

```bash
# Install skill
mkdir -p ~/.claude/skills/claude-code-optimizer
cp -r SKILL.md references ~/.claude/skills/claude-code-optimizer/

# Install agents
mkdir -p ~/.claude/agents
cp agents/*.md ~/.claude/agents/
```

### Project-Scoped Install

For project-specific installation (useful for teams):

```bash
./scripts/install.sh --project
```

This installs to `.claude/skills/` and `.claude/agents/` in your current directory.

### Verify Installation

```bash
claude --version  # Should be 2.1.0+
```

Then in Claude Code:
```
What skills are available?
```

You should see `claude-code-optimizer` listed.

## Usage

### Full Audit

Ask Claude Code to audit your setup:

```
Audit my Claude Code setup
```

Or be specific:

```
Run a comprehensive Claude Code audit and show me what needs fixing
```

### Targeted Audits

Run specific audits when you know what you're looking for:

| Request | What It Does |
|---------|--------------|
| `Check my Claude Code configuration` | Audits settings.json and CLAUDE.md files |
| `Audit my hooks` | Validates hook events, matchers, and security |
| `Review my permissions setup` | Analyzes allow/deny rules and pattern validity |
| `Audit my MCP servers` | Checks MCP configs for secrets and security |
| `Check my commands and agents` | Audits workflow components for best practices |
| `Run a security audit` | Comprehensive security review across all areas |

### Example Output

```
## Claude Code Audit Report

**Version**: 2.1.2
**Health**: ✅ Pass

### Findings

| Severity | Area | Issue | Fix |
|----------|------|-------|-----|
| 🔴 High | Hooks | Invalid event name `postToolUse` | Change to `PostToolUse` (case-sensitive) |
| 🟡 Medium | Permissions | Overly broad `Bash(*)` allow rule | Scope to specific commands |
| 🟢 Info | Config | No CLAUDE.md in project root | Consider adding project context |

### Recommendations
1. Fix the hook event name immediately—hooks won't fire with incorrect casing
2. Tighten Bash permissions to reduce security surface
3. Add CLAUDE.md to improve Claude's understanding of your project
```

## Architecture

```
┌──────────────────────────────────────────────────────────────────────┐
│                       Claude Code Optimizer                           │
├──────────────────────────────────────────────────────────────────────┤
│  SKILL.md                                                             │
│  ├── Trigger detection (audit, optimize, check, improve)             │
│  ├── Quick reference (settings keys, hook events, tool names)        │
│  └── Agent orchestration                                              │
├──────────────────────────────────────────────────────────────────────┤
│  Specialized Agents (6)                                               │
│  ┌────────────────┐  ┌────────────────┐  ┌────────────────┐          │
│  │ config-auditor │  │ hooks-auditor  │  │ permissions-   │          │
│  │                │  │                │  │ auditor        │          │
│  │ • settings.json│  │ • Event names  │  │ • Allow/deny   │          │
│  │ • CLAUDE.md    │  │ • Matchers     │  │ • Patterns     │          │
│  │ • Context size │  │ • Security     │  │ • Unreachable  │          │
│  └────────────────┘  └────────────────┘  └────────────────┘          │
│  ┌────────────────┐  ┌────────────────┐  ┌────────────────┐          │
│  │ mcp-auditor    │  │ workflow-      │  │ audit-         │          │
│  │                │  │ auditor        │  │ orchestrator   │          │
│  │ • MCP servers  │  │ • Commands     │  │ • Coordinates  │          │
│  │ • Secrets      │  │ • Agents       │  │ • Synthesizes  │          │
│  │ • Permissions  │  │ • Skills       │  │ • Prioritizes  │          │
│  └────────────────┘  └────────────────┘  └────────────────┘          │
├──────────────────────────────────────────────────────────────────────┤
│  References (5 guides, loaded on demand)                              │
│  • config-guide.md • hooks-guide.md • permissions-guide.md           │
│  • security-guide.md • troubleshooting.md                             │
└──────────────────────────────────────────────────────────────────────┘
```

### Why Subagents?

1. **Separation of concerns** — Each auditor is an expert in one domain
2. **Parallel execution** — Multiple audits can run simultaneously  
3. **Maintainability** — Update one auditor without touching others
4. **Context efficiency** — Only loads relevant expertise for each audit type
5. **Testability** — Each agent can be validated independently

## Documentation

### Included References

| Guide | Contents |
|-------|----------|
| [`references/config-guide.md`](references/config-guide.md) | Settings.json schema, CLAUDE.md best practices, context optimization |
| [`references/hooks-guide.md`](references/hooks-guide.md) | All 12 hook events, matcher patterns, input/output schemas |
| [`references/permissions-guide.md`](references/permissions-guide.md) | Permission strategies, pattern validation, unreachable rule detection |
| [`references/security-guide.md`](references/security-guide.md) | Security audit procedures, threat model, incident response |
| [`references/troubleshooting.md`](references/troubleshooting.md) | Common issues, diagnostic commands, context optimization |

### Official Claude Code Documentation

- [Skills](https://code.claude.com/docs/en/skills) — How skills work
- [Hooks Reference](https://code.claude.com/docs/en/hooks) — Complete hook documentation
- [Subagents](https://code.claude.com/docs/en/sub-agents) — Agent architecture
- [Settings](https://code.claude.com/docs/en/settings) — Configuration options

## What Gets Checked

### Configuration (`config-auditor`)
- `~/.claude/settings.json` — User settings
- `.claude/settings.json` — Project settings
- `CLAUDE.md` / `.claude/CLAUDE.md` — Project memory
- `CLAUDE.local.md` — Local overrides
- JSON validity and schema compliance
- Context usage optimization (file sizes, bloat detection)

### Hooks (`hooks-auditor`)
- All 12 event names validated (case-sensitive)
- Matcher patterns (regex validity, tool name accuracy)
- Command security (injection risks, data exfiltration, dangerous patterns)
- Timeout configurations
- `once: true` and `agent_type` options

### Permissions (`permissions-auditor`)
- Allow/deny rule effectiveness
- Pattern validation (catches common mistakes)
- Unreachable rule detection (2.1.3+)
- Conflicting rules and security recommendations

### MCP Servers (`mcp-auditor`)
- Server configurations in settings.json and .mcp.json
- Hardcoded secret detection
- Filesystem scope validation
- Tool permission coverage
- High-risk server identification

### Workflow Components (`workflow-auditor`)
- Custom slash commands (frontmatter, descriptions)
- Subagents (valid schemas, appropriate tools)
- Skills (trigger descriptions, file structure)
- Named sessions and `context: fork` usage

## Validation

This skill has passed comprehensive validation:

```
✅ 38/38 checks passed

Installation
  ✅ Skill directory structure correct
  ✅ Agents installed to correct location
  ✅ Install script executes successfully

Schema Validation
  ✅ SKILL.md frontmatter valid
  ✅ All 6 agents have valid frontmatter
  ✅ All tool names correct (Bash, Read, Write, etc.)
  ✅ All model values valid (inherit)

Documentation
  ✅ All 12 hook events documented
  ✅ All 5 reference guides complete
  ✅ SKILL.md under 500 lines
  ✅ Descriptions under 1024 chars

Version Compatibility
  ✅ Targets Claude Code 2.1.3+
  ✅ Tested with Claude Code 2.1.3
```

## Requirements

- **Claude Code**: 2.1.3 or later
- **Subscription**: Claude Pro, Claude Max, or API access
- **OS**: macOS, Linux, or Windows (WSL)

## File Structure

```
claude-code-optimizer/
├── SKILL.md                 # Main skill (triggers on audit/optimize requests)
├── MANIFEST.md              # Human-readable installation guide
├── HANDOFF.md               # Development context for contributors
├── QA-PROCESS.md            # Validation framework
├── README.md                # This file
├── LICENSE                  # MIT License
├── agents/
│   ├── audit-orchestrator.md    # Coordinates comprehensive audits
│   ├── config-auditor.md        # Configuration specialist
│   ├── hooks-auditor.md         # Hooks specialist
│   ├── mcp-auditor.md           # MCP server specialist
│   ├── permissions-auditor.md   # Permissions specialist
│   └── workflow-auditor.md      # Commands/agents/skills specialist
├── references/
│   ├── config-guide.md          # Configuration deep-dive
│   ├── hooks-guide.md           # Hook patterns and examples
│   ├── permissions-guide.md     # Permission strategies
│   ├── security-guide.md        # Security audit procedures
│   └── troubleshooting.md       # Common issues and solutions
└── scripts/
    └── install.sh               # Installation script
```

## Contributing

Contributions are welcome! Please see [HANDOFF.md](HANDOFF.md) for development context and [QA-PROCESS.md](QA-PROCESS.md) for the validation framework.

### Development Workflow

1. Fork the repository
2. Make your changes
3. Run the QA process validation
4. Submit a pull request

### Areas for Contribution

- Additional audit checks
- New reference documentation
- Edge case handling
- Performance optimization
- Bug fixes

## License

MIT License — see [LICENSE](LICENSE) for details.

## Attribution

<div align="center">

**Designed by Anthony Velte & Claude Opus 4.5**

Built with care to help developers get the most out of Claude Code.

---

*If this skill helped you, consider starring the repo ⭐*

</div>
