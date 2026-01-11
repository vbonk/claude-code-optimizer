# Permissions Audit Guide

## Permission Model

Claude Code uses a permission-based model:
- Default: Read-only, asks permission for modifications
- Configurable: Pre-allow or deny specific operations
- Scoped: User-level, project-level, or managed

## Configuration Location

```json
// In settings.json
{
  "permissions": {
    "allow": [...],
    "deny": [...]
  }
}
```

## Permission Syntax

### Basic Tool Permissions
```json
{
  "allow": ["Read", "Grep", "Glob"],
  "deny": ["Write"]
}
```

### Parameterized Permissions
```json
{
  "allow": [
    "Bash(git status:*)",
    "Bash(npm test:*)",
    "Bash(ls:*)"
  ]
}
```

Format: `Tool(pattern:description_pattern)`

### Wildcard Patterns
| Pattern | Matches |
|---------|---------|
| `Bash(git *:*)` | All git commands |
| `Bash(*test*:*)` | Commands containing "test" |
| `Edit(*.ts:*)` | Edit any TypeScript file |
| `Task(*)` | All subagent invocations |
| `Task(test-runner)` | Specific subagent only |

## Permission Precedence

1. Deny rules take precedence over allow
2. More specific rules override general rules
3. Project settings override user settings
4. Managed settings override all

## Built-in Safe Commands

These commands are auto-allowed (read-only):
- `cat`, `head`, `tail`, `less`
- `ls`, `find`, `tree`
- `echo`, `printf`
- `git status`, `git log`, `git diff`
- `pwd`, `whoami`, `date`

## Common Permission Patterns

### Development Workflow
```json
{
  "permissions": {
    "allow": [
      "Bash(git add:*)",
      "Bash(git commit:*)",
      "Bash(git push:*)",
      "Bash(npm *:*)",
      "Bash(yarn *:*)",
      "Bash(pnpm *:*)"
    ]
  }
}
```

### Read-Only Mode
```json
{
  "permissions": {
    "allow": ["Read", "Grep", "Glob"],
    "deny": ["Write", "Edit", "Bash"]
  }
}
```

### Production Safety
```json
{
  "permissions": {
    "deny": [
      "Bash(rm -rf:*)",
      "Bash(sudo *:*)",
      "Bash(*prod*:*)",
      "Edit(.env*:*)",
      "Write(.env*:*)"
    ]
  }
}
```

## MCP Tool Permissions

MCP tools follow pattern: `mcp__servername__toolname`

```json
{
  "permissions": {
    "allow": [
      "mcp__github__list_prs",
      "mcp__github__pr_review"
    ],
    "deny": [
      "mcp__github__delete_*"
    ]
  }
}
```

### Server-Level Wildcards (2.0.70+)
Allow or deny all tools from an MCP server:
```json
{
  "permissions": {
    "allow": ["mcp__filesystem__*"],
    "deny": ["mcp__dangerous_server__*"]
  }
}
```

## Subagent Permissions

Disable specific subagents:
```json
{
  "permissions": {
    "deny": ["Task(dangerous-agent)"]
  }
}
```

## Audit Procedure

1. **Review current permissions**
   ```bash
   cat ~/.claude/settings.json | jq '.permissions'
   cat .claude/settings.json | jq '.permissions'
   ```

2. **Check for overly permissive rules**
   - `Bash(*)` allows all commands
   - `*` in allow is dangerous

3. **Verify deny rules are effective**
   - Test that blocked operations are actually blocked
   - Check for bypasses via other tools

4. **Review subagent permissions**
   - Subagents inherit parent permissions by default
   - Can be restricted via `tools` field

5. **Check MCP server permissions**
   - Review each connected MCP server
   - Audit allowed tools per server

## Unreachable Rule Detection (2.1.3+)

Claude Code 2.1.3 detects and warns about unreachable permission rules.

### What Makes a Rule Unreachable
- A deny rule that comes after a broader allow (never evaluated)
- Duplicate rules (same pattern twice)
- Rules shadowed by earlier broader rules

### Example Problem
```json
{
  "permissions": {
    "allow": ["Bash(*)"],       // Allows ALL bash commands
    "deny": ["Bash(rm -rf:*)"]  // UNREACHABLE - never evaluated!
  }
}
```

### Fix
Reorder rules or use more specific allows:
```json
{
  "permissions": {
    "allow": [
      "Bash(git *:*)",
      "Bash(npm *:*)"
    ],
    "deny": ["Bash(rm -rf:*)"]
  }
}
```

## Common Issues

| Issue | Cause | Fix |
|-------|-------|-----|
| Permission prompts despite allow | Typo in pattern | Check exact syntax |
| Can't deny specific command | Allow rule too broad | Make allow more specific |
| Subagent bypasses restrictions | Missing Task deny | Add `Task(agent-name)` to deny |
| Unreachable rule warning | Rule order issue | Reorder or narrow broader rules |
