# Oh My Fish init hook for plugin-claude-ai

# Verify claude is available
if not command -q claude
    echo "plugin-claude-ai: 'claude' (Claude Code CLI) not found in PATH" >&2
    echo "  Install: npm install -g @anthropic-ai/claude-code" >&2
    return 1
end

# Source key bindings
source (status dirname)/conf.d/claude_ai.fish
