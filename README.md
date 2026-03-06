# plugin-claude-ai

AI-powered shell assistance for [Fish](https://fishshell.com) via [Claude Code](https://docs.anthropic.com/en/docs/claude-code). Inspired by [fish-ai](https://github.com/Realiserad/fish-ai), but backed by Claude Code's CLI — no API keys to manage, no Python venv, no separate LLM configuration.

## Features

| Keybinding | Action |
|---|---|
| <kbd>Ctrl+P</kbd> | **Smart transform** — type a `# comment` and press to generate a command; type a command and press to get an explanation |
| <kbd>Ctrl+Space</kbd> | **AI completions** — generate 5 candidate completions and select via `fzf`; on empty buffer after a failure, suggests a fix |
| <kbd>Ctrl+X</kbd> | **Fix last command** — rewrites the most recent failed command |

All keybindings are configurable. See [Configuration](#configuration).

## Prerequisites

- [Fish shell](https://fishshell.com) ≥ 3.4
- [Claude Code CLI](https://docs.anthropic.com/en/docs/claude-code) (`claude` in `$PATH`)
- [fzf](https://github.com/junegunn/fzf) (optional, for interactive completion selection)

## Installation

### Fisher (recommended)

```fish
fisher install <your-github-username>/plugin-claude-ai
```

### Oh My Fish

```fish
omf install https://github.com/<your-github-username>/plugin-claude-ai
```

### Manual

Clone the repo and symlink or copy into your fish config:

```fish
git clone https://github.com/<your-github-username>/plugin-claude-ai.git
cp -r plugin-claude-ai/functions/* ~/.config/fish/functions/
cp -r plugin-claude-ai/completions/* ~/.config/fish/completions/
cp -r plugin-claude-ai/conf.d/* ~/.config/fish/conf.d/
```

## Usage

### Generate a command from natural language

```
# list all docker containers sorted by memory usage<Ctrl+P>
```

The `#` prefix is stripped and sent to Claude Code. The buffer is replaced with the generated command.

### Explain a command

```
find . -name '*.log' -mtime +30 -delete<Ctrl+P>
```

Without a `#` prefix, the command is sent for explanation. Output is printed below the prompt in dim text; the buffer is untouched.

### AI-powered completions

```
git rebase<Ctrl+Space>
```

Claude generates 5 plausible completions. If `fzf` is installed, an interactive selector appears. Otherwise, the first suggestion is used.

### Fix the last failed command

Press <kbd>Ctrl+X</kbd> at an empty (or any) prompt. The most recent history entry is sent to Claude for correction and the buffer is replaced.

## Configuration

### Custom keybindings

Set these variables **before** the plugin loads (e.g., in `~/.config/fish/config.fish`):

```fish
set -g CLAUDE_AI_BIND_TRANSFORM \cp   # default: Ctrl+P
set -g CLAUDE_AI_BIND_COMPLETE  \x20  # default: Ctrl+Space
set -g CLAUDE_AI_BIND_FIX       \cx   # default: Ctrl+X
```

### Disable the plugin

```fish
set -g CLAUDE_AI_DISABLED 1
```

Restart your shell or `exec fish` to apply.

### Vi mode

Key bindings are automatically registered in insert mode when `fish_vi_key_bindings` is active.

## Functions

All functions are available standalone:

| Function | Description |
|---|---|
| `claude_ai_cmd` | Natural language → shell command |
| `claude_ai_explain` | Command → plain English explanation |
| `claude_ai_fix` | Fix the last failed command |
| `claude_ai_transform` | Smart dispatcher (comment ↔ command) |
| `claude_ai_complete` | Multi-candidate completion with fzf |

## How it works

Each invocation calls `claude -p` (print mode) — a single-shot, stateless query to Claude Code. No conversation context is retained between invocations. The OS name is included in the prompt so Claude generates platform-appropriate commands.

### Comparison with fish-ai

| | plugin-claude-ai | fish-ai |
|---|---|---|
| Backend | Claude Code CLI | Direct HTTP (multi-provider) |
| Dependencies | Node.js (Claude Code) | Python venv |
| Auth | Claude Code handles it | Manual API key management |
| Latency | Higher (Node startup) | Lower (direct HTTP) |
| Provider lock-in | Anthropic only | Multi-provider |
| Shell history context | Not sent | Optional |

## License

[MIT](LICENSE)
