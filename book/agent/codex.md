## Config
Create a dedicated file for each profile (e.g., work.config.toml or personal.config.toml) in your $CODEX_HOME

codex --profile <profile-name>
```toml
# Model Behavior — pin only when your workflow requires it
model = "gpt-5.5"
model_reasoning_effort = "high"

# Runtime Environment — pass only the env vars this repo needs
[shell_environment_policy]
include_only = ["PATH", "HOME"]

# Approvals & Sandbox
approval_policy = "on-request"
sandbox_mode = "workspace-write"

# Project Settings
project_doc_max_bytes = 65536
web_search = "cached"

# Tools & Integrations
[mcp_servers.github]
command = "github-mcp"

# Optional Capabilities
[features]
memories = true
```

# Codex Agent Notes

## Memories
```
toml[features]
memories = true
```
https://mem0.ai/blog/how-memory-works-in-codex-cli
## Agents.md

Keep it short: Aim for 200–300 lines. Performance degrades significantly past 500 lines as models get overwhelmed by excessive instructions.

Put commands early: Place exact executable commands (e.g., npm test, pytest -v, bun run build) at the very top with specific flags.

Code over prose: Use brief code snippets to demonstrate coding style and expected outputs instead of long paragraphs.

Set hard boundaries: Explicitly list what the agent must never touch, such as vendor directories, secrets, or production configuration files.

## Layering Files for Agent Instructions

Conflicting instructions and context can be avoided by layering `AGENTS.md` files at different scopes:

| Location | Type | Visibility | Purpose |
|---|---|---|---|
| `~/.codex/AGENTS.md` | Personal defaults | Private | Your personal preferences – communication styles, etc. |
| `workspace/AGENTS.md` | Repo-level instructions | Shared | Repository-wide standards shared by everyone |
| `workspace/apps/web/AGENTS.md` | Directory-level instructions | Shared | Parts of the repo that operate differently (mobile, payments, etc.) |
| `workspace/services/payments/AGENTS.override.md` | Overrides | Shared | Intentional exceptions – local policies, specialized requirements |

**Key principle:** More specific (deeper) files take precedence. Overrides (`.override.md`) allow intentional exceptions without editing shared defaults.

## Rules (`.rules`)

Rules control which commands Codex can run **outside the sandbox**. Add `.rules` files under `rules/` — each rule needs `pattern + decision + justification`.

```starlark
# ~/.codex/rules/default.rules
prefix_rule(
    pattern   = ["git", "push"],
    decision  = "prompt",
    justification = "Confirm before publishing changes.",
)
```

**Use for:**
- Blocking destructive shell commands
- Requiring approval for deploys, pushes, migrations
- Enforcing team safety policies across Codex runs

**Not for:**
- Teaching repo behavior → use `AGENTS.md`
- Running commands automatically → use hooks
- Expanding file access → use writable roots

## Hooks (`/hooks`)

Hooks automatically run shell commands at specific points in the Codex workflow — useful for formatting, linting, testing, or regenerating files at key stages.

Configure in `~/.codex/config.toml`. Hook events: `PreToolUse`, `PostToolUse`, `PreCompact`, `SubagentStart`, `Stop`.

```toml
# ~/.codex/config.toml

[[hooks.PreToolUse]]
matcher = "^Bash$"

[[hooks.PreToolUse.hooks]]
type    = "command"
command = "/usr/bin/python3 '$(git rev-parse --show-toplevel)/.codex/hooks/pre_tool_use_policy.py'"
timeout = 30
statusMessage = "Checking Bash command"
```

**Use for:**
- Running repeatable checks before Codex submits work
- Formatting, linting, testing, regenerating files
- Updating docs or generated artifacts after changes



**Not for:**
- Blocking risky shell commands → use Rules
- Limiting file or network access → use permissions
- Teaching repo context → use `AGENTS.md`


## Status line

Use `/statusline` to customize what Codex shows in the CLI while a task is running.

- Surface useful session context such as the model, branch, sandbox, or token usage.
- Monitor long-running or parallel sessions.

## Sub-agents

Use `/agent` to delegate scoped work to specialized, parallel threads.

### Use for

- Splitting a large task into focused workstreams.
- Assigning research, review, implementation, or monitoring to specialist roles.
- Synthesizing the results of multiple workstreams.

Example request:

> Review merchandising, checkout, and release in separate scoped sub-agents.

### Not for

- Isolating local Git branches; use Worktrees instead.
- Exploring a separate Codex path; use `/fork` instead.


## Custom agents
You can create custom agents in Codex by placing standalone TOML configuration files in your global or project-level .codex/agents/ directory.Where to Save Custom AgentsPersonal agents (global): Save as ~/.codex/agents/<agent-name>.toml.Project-scoped agents: Save as .codex/agents/<agent-name>.toml in your project root.Required Configuration FieldsEvery custom agent file must contain these three core keys:name: The identifier Codex uses when spawning or referencing the agent.description: Human-facing guidance explaining when Codex should trigger the agent.developer_instructions: Core instructions defining the specific behavior of the agent.You can also optionally configure parameters like model, model_reasoning_effort, sandbox_mode, and mcp_servers inside the TOML file. If omitted, they inherit settings from the parent session.

## Worktrees

Use `git worktree` to create separate local working directories for separate branches.

- Isolate experiments, bug fixes, and feature work.
- Let multiple Codex sessions work in parallel without competing for one checkout.

To create a separate checkout for a branch:

```bash
git worktree add ../<branch-name> -b <branch-name>
```

## Forking

Use `/fork` to create an independent Codex path from the current task.

- Explore another implementation without disrupting the main thread.
- Prototype a risky idea or compare uncertain approaches before committing to one.

To branch the current Codex task into a new path:

```text
/fork <alternate approach>
```

Use Worktrees instead when you need local Git branches or multiple checkouts running side by side.