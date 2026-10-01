

# cursor cli

## locations
- `~/.cursor/mcp.json`

## slash commands
- /sandbox
- /run-everything

## agent persistence
- `agent ls` - list previous agent sessions
- `agent resume` - resume the latest session
- `agent --continue` - continue the previous session
- `agent --resume="chat-id-here"` - resume a specific session
- Sandbox settings configured with `/sandbox` persist across sessions.

## herder and tmux
- **Herder** coordinates multiple agent workers: it can assign separate tasks, track their progress, and collect results.
- **tmux** keeps the terminal processes running independently of the current terminal window, making long-running agents easy to detach from and reattach to.
- A practical setup is one tmux window or pane per worker, with Herder managing the work and Cursor `agent` running inside each pane.

```bash
tmux new -s agents
tmux split-window -h
tmux attach -t agents
tmux detach
```

## prompts
- what is my allowlist (also in `~/.cursor/cli-config.json`)


## ref
https://cursor.com/docs/cloud-agent/self-hosted 