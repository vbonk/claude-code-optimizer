# Hooks Audit Guide

## Hook Configuration Structure

```json
{
  "hooks": {
    "EventName": [
      {
        "matcher": "ToolPattern",
        "hooks": [
          {
            "type": "command",
            "command": "your-command",
            "timeout": 60
          }
        ]
      }
    ]
  }
}
```

## Event Names (2.1.0+)

| Event | When Fired | Can Block |
|-------|------------|-----------|
| `PreToolUse` | Before tool execution | Yes |
| `PostToolUse` | After tool completion | No |
| `PostToolUseFailure` | After tool fails | No |
| `PermissionRequest` | Permission dialog shown | Yes |
| `Notification` | Notification sent | No |
| `UserPromptSubmit` | User submits prompt | Yes |
| `SessionStart` | Session begins/resumes | No |
| `SessionEnd` | Session ends | No |
| `Stop` | Claude finishes responding | Yes |
| `SubagentStart` | Subagent task begins | No |
| `SubagentStop` | Subagent completes | Yes |
| `PreCompact` | Before compaction | No |

## Matcher Patterns

| Pattern | Matches |
|---------|---------|
| `Bash` | Exact match: Bash tool only |
| `Edit\|Write` | Either Edit or Write |
| `*` | All tools |
| `""` (empty) | All tools |
| `mcp__github__*` | All GitHub MCP tools |
| `mcp__server__*` | All tools from specific MCP server |
| `Task` | All subagent invocations |
| `TaskOutput` | Background task result retrieval |

## Hook Input Schema

All hooks receive JSON on stdin:
```json
{
  "session_id": "abc123",
  "transcript_path": "/path/to/transcript.jsonl",
  "cwd": "/current/directory",
  "hook_event_name": "PreToolUse",
  "tool_name": "Bash",
  "tool_input": {
    "command": "ls -la",
    "description": "List files"
  }
}
```

### SessionStart Input (2.1.2+)
When `--agent` flag is specified, SessionStart receives additional field:
```json
{
  "session_id": "abc123",
  "cwd": "/current/directory",
  "hook_event_name": "SessionStart",
  "agent_type": "custom-agent"
}
```

Use `agent_type` for agent-specific initialization logic.

## Hook Output (Exit Codes)

| Exit Code | Meaning |
|-----------|---------|
| 0 | Success, continue |
| 2 | Block operation (PreToolUse only) |
| Other | Error, continue anyway |

## Hook Output (JSON)

For advanced control, output JSON:
```json
{
  "decision": "approve",
  "reason": "Auto-approved safe command",
  "suppressOutput": true
}
```

### PreToolUse Decisions
- `"approve"` - Allow without permission prompt
- `"block"` - Block with reason
- `"ask"` - Show permission dialog (default)

## Frontmatter Hooks (2.1.0+)

Skills, agents, and commands can define scoped hooks:
```yaml
---
name: my-skill
hooks:
  PreToolUse:
    - matcher: "Bash"
      hooks:
        - type: command
          command: "./validate.sh"
          once: true
---
```

The `once: true` option runs hook only once per session.

## Common Hook Patterns

### Logging
```json
{
  "hooks": {
    "PreToolUse": [{
      "matcher": "Bash",
      "hooks": [{
        "type": "command",
        "command": "jq -r '.tool_input.command' >> ~/.claude/command-log.txt"
      }]
    }]
  }
}
```

### Auto-formatting
```json
{
  "hooks": {
    "PostToolUse": [{
      "matcher": "Edit|Write",
      "hooks": [{
        "type": "command",
        "command": "jq -r '.tool_input.file_path' | xargs -I{} prettier --write {}"
      }]
    }]
  }
}
```

### File Protection
```json
{
  "hooks": {
    "PreToolUse": [{
      "matcher": "Edit|Write",
      "hooks": [{
        "type": "command",
        "command": "jq -r '.tool_input.file_path' | grep -q '.env' && exit 2 || exit 0"
      }]
    }]
  }
}
```

## Audit Checklist

1. **Verify event names are valid** (case-sensitive)
2. **Check matcher patterns compile** (regex syntax)
3. **Test commands manually** before registering
4. **Verify timeouts are reasonable** (default: 60s)
5. **Check for security issues** in hook commands
6. **Ensure hooks don't create infinite loops**

## Security Considerations

- Hooks run with your credentials
- Malicious hooks can exfiltrate data
- Always review hook commands before adding
- Use `$CLAUDE_PROJECT_DIR` for relative paths
