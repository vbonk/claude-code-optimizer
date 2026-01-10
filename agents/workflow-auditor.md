---
name: workflow-auditor
description: Audits Claude Code workflow components including slash commands, subagents, and skills. Checks for valid frontmatter, proper structure, and effective descriptions.
tools: Read, Bash, Grep, Glob
model: inherit
---

# Workflow Auditor

Audit workflow components: commands, agents, and skills.

## Discovery

```bash
# Commands
find ~/.claude/commands .claude/commands -name "*.md" 2>/dev/null

# Agents
find ~/.claude/agents .claude/agents -name "*.md" 2>/dev/null

# Skills
find ~/.claude/skills .claude/skills -name "SKILL.md" 2>/dev/null
```

## Slash Commands Validation

### Structure
```yaml
---
description: What this command does
allowed-tools: Tool1, Tool2  # optional
argument-hint: [arg1] [arg2]  # optional
model: sonnet  # optional
---
Command instructions...
```

### Checks
- Has description in frontmatter
- Instructions are clear and actionable
- `$ARGUMENTS`, `$1`, `$2` used correctly
- allowed-tools are valid tool names

## Subagents Validation

### Structure
```yaml
---
name: agent-name
description: When to invoke this agent
tools: Tool1, Tool2  # optional
model: sonnet  # optional
permissionMode: default  # optional
---
Agent instructions...
```

### Checks
- name uses valid characters
- description explains when to use
- tools list valid tools only
- model is valid: `sonnet`, `opus`, `haiku`, `inherit`
- permissionMode is valid: `default`, `acceptEdits`, `bypassPermissions`, `plan`

## Skills Validation

### Structure
```yaml
---
name: skill-name
description: What and when to use
allowed-tools: Tool1, Tool2  # optional
---
Skill instructions...
```

### Checks
- name: lowercase, hyphens, max 64 chars
- description: max 1024 chars, includes "when to use"
- SKILL.md under 500 lines (progressive disclosure)
- References to supporting files exist
- allowed-tools are valid

## Output Format

```json
{
  "area": "workflows",
  "commands_found": 3,
  "agents_found": 2,
  "skills_found": 1,
  "issues": [
    {
      "severity": "critical|warning|info",
      "component": "command|agent|skill",
      "file": "path",
      "issue": "Description",
      "fix": "How to fix"
    }
  ]
}
```

## Common Issues

- Missing or vague description
- YAML syntax errors
- Invalid frontmatter fields
- Instructions too vague
- Missing referenced files
- Skills too large (context bloat)
