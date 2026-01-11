# Troubleshooting Guide

## Diagnostic Commands

```bash
# Check version
claude --version

# Debug mode (shows loading errors)
claude --debug

# View context usage
# (In Claude Code) /context

# View installed plugins
# (In Claude Code) /plugins

# View hooks configuration
# (In Claude Code) /hooks
```

## Common Issues

### Skills Not Loading

**Symptoms**: Skill not appearing, not triggered when expected

**Checks**:
1. Verify path: `~/.claude/skills/skill-name/SKILL.md` or `.claude/skills/skill-name/SKILL.md`
2. Check YAML frontmatter (no tabs, valid syntax)
3. Verify `name` uses lowercase and hyphens only
4. Check `description` is specific enough for triggering
5. Run `claude --debug` to see loading errors

**Fix**: YAML must start on line 1 with `---`, no blank lines before it.

### Hooks Not Firing

**Symptoms**: Expected hook behavior doesn't occur

**Checks**:
1. Event names are case-sensitive: `PreToolUse` not `pretooluse`
2. Matcher pattern is valid regex
3. Command exists and is executable
4. JSON output format is correct (if using JSON)

**Fix**: Test hook command manually:
```bash
echo '{"tool_name":"Bash","tool_input":{"command":"ls"}}' | your-hook-command
```

### CLAUDE.md Not Being Read

**Symptoms**: Instructions in CLAUDE.md ignored

**Checks**:
1. File is in project root or `.claude/` directory
2. File name is exactly `CLAUDE.md` (case-sensitive)
3. File is not too large (causes context issues)
4. No syntax errors preventing parsing

**Fix**: Keep CLAUDE.md under 1000 lines; split into `.claude/rules/` if needed.

### Permission Prompts Still Appearing

**Symptoms**: Allowed operations still prompt for permission

**Checks**:
1. Pattern syntax matches exactly
2. Settings file is valid JSON
3. Correct settings file is being read (project vs user)
4. No deny rule blocking the allow

**Fix**: Use wildcards correctly:
- `Bash(git:*)` - only matches "git" with any description
- `Bash(git *:*)` - matches "git status", "git commit", etc.

### Subagents Not Invoking

**Symptoms**: Subagent not used when expected

**Checks**:
1. File in `~/.claude/agents/` or `.claude/agents/`
2. File extension is `.md`
3. Frontmatter has valid `name` and `description`
4. Not blocked by deny rule: `Task(agent-name)`

**Fix**: Restart Claude Code after adding new agents.

### MCP Servers Not Connecting

**Symptoms**: MCP tools unavailable

**Checks**:
1. Server configuration in settings or `.mcp.json`
2. Server is running and accessible
3. No firewall/network blocking
4. Use `--mcp-debug` flag for diagnostics

**Fix**: Check MCP server logs for connection errors.

### Context Exhaustion

**Symptoms**: Claude losing track of conversation, compacting frequently

**Checks**:
1. CLAUDE.md size (target < 200 lines)
2. Number of files in context
3. Rules files size (total < 500 lines)
4. Transcript length
5. Background agents running

**Quick Diagnostics**:
```bash
# Check configuration sizes
wc -l CLAUDE.md .claude/CLAUDE.md 2>/dev/null
find .claude/rules -name "*.md" -exec wc -l {} \; 2>/dev/null

# In Claude Code
/context  # See current usage
/stats    # See session statistics
```

**Fix**:
- Reduce CLAUDE.md size (move to rules/)
- Use `/compact` command proactively
- Split large rules with `paths:` scoping
- Close background agents: use `KillShell` or restart
- Use `/clear` for fresh context

### Context Optimization Best Practices

**Configuration Sizing**:
| Item | Target | Action if exceeded |
|------|--------|-------------------|
| CLAUDE.md | < 200 lines | Split to rules/ |
| Single rule | < 100 lines | Break into focused files |
| Total rules | < 500 lines | Use paths: scoping |

**Reduce Context Load**:
- Use `@filename` imports sparingly
- Scope rules with `paths:` patterns
- Avoid loading files you don't need
- Close completed background tasks

**Proactive Management**:
- Run `/compact` before large tasks
- Use `/clear` between unrelated tasks
- Name sessions (`/rename`) for easy context switching
- Review `/context` output regularly

### Session Persistence Issues

**Symptoms**: Session state lost between reconnects

**Checks**:
1. Using `/teleport` correctly
2. Session not expired
3. Network connectivity stable

**Fix**: Use checkpoints (`Esc Esc` to rewind) for recovery.

## Debug Output Interpretation

When running `claude --debug`:

```
[DEBUG] Loading user settings from ~/.claude/settings.json
[DEBUG] Loading project settings from .claude/settings.json
[DEBUG] Found skill: my-skill at ~/.claude/skills/my-skill/SKILL.md
[DEBUG] Registering hook: PreToolUse matcher=Bash
[ERROR] Invalid YAML in SKILL.md: ...
```

- `Loading` messages show which files are read
- `Found` messages confirm discovery
- `Registering` shows successful hook setup
- `ERROR` indicates problems to fix

## Performance Issues

### Slow Startup
- Too many plugins installed
- Large CLAUDE.md files
- Many MCP servers connecting

### Slow Responses
- Complex hook commands
- Slow MCP server responses
- Large context window

### High Memory
- Long sessions without compact
- Many background agents
- Large file reads

**Fix**: Regular `/compact`, close unused agents, restart periodically.

## Getting Help

1. `/bug` command to report issues
2. Check GitHub issues: github.com/anthropics/claude-code/issues
3. Join Discord: anthropic.com/discord
4. Check status: status.anthropic.com
