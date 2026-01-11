# Security Audit Guide

## Overview

This guide covers security auditing for Claude Code configurations. Security is critical because Claude Code runs with your permissions and can execute arbitrary commands.

## Threat Model

### What Can Go Wrong

| Threat | Vector | Impact |
|--------|--------|--------|
| Data exfiltration | Hooks, MCP servers | Secrets/code sent externally |
| Code injection | Unquoted variables in hooks | Arbitrary command execution |
| Privilege escalation | sudo in hooks, broad permissions | System compromise |
| Credential theft | Hardcoded secrets, env exposure | Account compromise |
| Persistence | Modifications to shell configs | Long-term access |

### Trust Boundaries

1. **User settings** (`~/.claude/`) - You control these
2. **Project settings** (`.claude/`) - Could be malicious from cloned repos
3. **MCP servers** - Third-party code with network/file access
4. **Hooks** - Execute with your full permissions
5. **Skills** - Can invoke any tool Claude has access to

## Security Audit Checklist

### Configuration Files

```bash
# Check for secrets in configuration
grep -riE '(api[_-]?key|secret|password|token|credential)' ~/.claude/ .claude/ 2>/dev/null

# Check for suspicious patterns
grep -riE '(curl|wget|nc |eval|exec|base64)' ~/.claude/ .claude/ 2>/dev/null
```

**Flags**:
- [ ] No hardcoded secrets in settings.json
- [ ] No hardcoded secrets in .mcp.json
- [ ] No suspicious commands in hooks
- [ ] Project settings reviewed before use

### Hooks Security

**Critical Patterns to Block**:
```bash
# Data exfiltration
curl, wget, nc, ssh, scp

# Code injection
eval, exec, source, bash -c

# Obfuscation
base64 -d | bash, gunzip | bash

# System modification
> /etc/, > ~/.bashrc, > ~/.zshrc, chmod
```

**Safe Hook Patterns**:
```json
{
  "hooks": {
    "PreToolUse": [{
      "matcher": "Bash",
      "hooks": [{
        "type": "command",
        "command": "jq -r '.tool_input.command' | grep -q 'rm -rf /' && exit 2 || exit 0"
      }]
    }]
  }
}
```

### MCP Server Security

**Before Adding Any MCP Server**:
1. Verify source is trusted (official, reputable)
2. Review what permissions it requires
3. Understand what data it can access
4. Set up deny rules for dangerous tools

**High-Risk Server Types**:
| Type | Risk | Required Action |
|------|------|-----------------|
| filesystem | Can read/write any file | Scope to project only |
| shell/exec | Arbitrary command execution | Avoid if possible |
| fetch/http | Network access | Review URLs accessed |
| database | Data access | Never use prod creds |
| browser | Full browser control | Review carefully |

### Permission Security

**Dangerous Permission Patterns**:
```json
// NEVER DO THIS
{
  "permissions": {
    "allow": ["*"],           // Allows everything
    "allow": ["Bash(*)"],     // Allows all commands
    "allow": ["Bash(sudo *:*)"] // Allows sudo
  }
}
```

**Safe Permission Patterns**:
```json
{
  "permissions": {
    "allow": [
      "Bash(git *:*)",        // Specific tool
      "Bash(npm test:*)",     // Specific command
      "Read"                  // Read-only tool
    ],
    "deny": [
      "Bash(rm -rf *:*)",     // Block dangerous
      "Bash(sudo *:*)",       // Block sudo
      "Bash(curl *:*)",       // Block network
      "mcp__*__delete_*"      // Block MCP deletes
    ]
  }
}
```

## Reviewing Cloned Projects

When cloning a repo with `.claude/` directory:

### Before Using

1. **Inspect settings.json**:
   ```bash
   cat .claude/settings.json | jq .
   ```

2. **Check for hooks**:
   ```bash
   cat .claude/settings.json | jq '.hooks'
   ```

3. **Check for MCP servers**:
   ```bash
   cat .claude/settings.json | jq '.mcpServers'
   cat .mcp.json 2>/dev/null
   ```

4. **Review rules files**:
   ```bash
   find .claude/rules -name "*.md" -exec cat {} \;
   ```

### Red Flags

- Hooks with network commands (curl, wget)
- MCP servers you don't recognize
- Broad permission allows
- Commands with eval, exec, base64
- References to external URLs
- Requests to run with `--dangerously-skip-permissions`

## Incident Response

### If You Suspect Compromise

1. **Stop Claude Code immediately** (Ctrl+C, close terminal)
2. **Review recent commands**:
   ```bash
   cat ~/.claude/command-log.txt  # If logging enabled
   history | tail -50
   ```
3. **Check for persistence**:
   ```bash
   cat ~/.bashrc ~/.zshrc | grep -v "^#"
   crontab -l
   ```
4. **Rotate compromised credentials**
5. **Review and clean configurations**:
   ```bash
   cat ~/.claude/settings.json
   rm -i ~/.claude/settings.json  # If compromised
   ```

### Reporting Security Issues

- Claude Code issues: github.com/anthropics/claude-code/security
- MCP server issues: Report to server maintainer
- This skill: github.com/vbonk/claude-code-optimizer/issues

## Security Best Practices

1. **Principle of least privilege** - Only allow what's needed
2. **Review before trust** - Check project configs before use
3. **Use deny rules** - Explicitly block dangerous operations
4. **Environment variables** - Never hardcode secrets
5. **Regular audits** - Run this optimizer periodically
6. **Stay updated** - Keep Claude Code current
7. **Monitor logs** - Enable command logging if needed
8. **Separate environments** - Different configs for different trust levels
