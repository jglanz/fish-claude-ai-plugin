# Oh My Fish init hook for plugin-claude-ai

# Verify claude is available
if not command -q claude
    echo "plugin-claude-ai: 'claude' (Claude Code CLI) not found in PATH" >&2
    echo "  Install: npm install -g @anthropic-ai/claude-code" >&2
    return 1
end

# Source key bindings
set currentDir (dirname (realpath (status filename)))
if not test -d $currentDir/conf.d
    set currentDir (realpath $currentDir/..)
end
if not test -d $currentDir/conf.d
    echo "plugin-claude-ai: Configuration directory not found: $currentDir/conf.d" >&2
    return 1
end

set claude_ai_conf $currentDir/conf.d/claude_ai.fish
if test -f $claude_ai_conf
    source $claude_ai_conf
else
    echo "plugin-claude-ai: Configuration file not found: $claude_ai_conf" >&2
    return 1
end