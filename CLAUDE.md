# CLAUDE.md

> Instructions for Claude Code when working in this repository.

## Project

**Name:** Claude Code Optimizer
**Type:** Claude Code Skill (audit/optimization tool)
**Target:** Claude Code 2.1.0+

## What This Is

A skill that audits and optimizes Claude Code installations. Uses a subagent architecture with 5 specialized auditors coordinated by an orchestrator.

## Project Structure

```
SKILL.md              # Main skill entry point (Claude reads this)
HANDOFF.md            # Project context for session continuity
QA-PROCESS.md         # Verification framework
agents/               # 5 specialized auditor agents
references/           # Deep-dive guides (progressive disclosure)
scripts/install.sh    # Installation script
```

## Key Files

- `SKILL.md` — The skill definition Claude loads
- `agents/audit-orchestrator.md` — Coordinates full audits
- `agents/*-auditor.md` — Specialized auditors (config, hooks, permissions, workflow)
- `references/*.md` — Detailed guides loaded on-demand

## Workflow

- This is a documentation/skill project, not a code project
- No build system, tests, or linting
- Changes should follow existing Markdown patterns
- Use conventional commits (feat:, fix:, docs:)

## Design Principles

1. **Lean SKILL.md** — Keep under 500 lines, use references/ for details
2. **Progressive disclosure** — Load context only when needed
3. **Actionable output** — Every finding should include a specific fix
4. **Currency** — Verify against latest Claude Code docs before claiming correctness

## References

- Official docs: code.claude.com/docs/en/skills
- Hooks docs: code.claude.com/docs/en/hooks
- See `HANDOFF.md` for full project context
