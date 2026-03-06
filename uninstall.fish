# Oh My Fish uninstall hook for plugin-claude-ai

# Remove key bindings
bind --erase $CLAUDE_AI_BIND_TRANSFORM 2>/dev/null
bind --erase $CLAUDE_AI_BIND_COMPLETE 2>/dev/null
bind --erase $CLAUDE_AI_BIND_FIX 2>/dev/null

if test "$fish_key_bindings" = fish_vi_key_bindings
    bind -M insert --erase $CLAUDE_AI_BIND_TRANSFORM 2>/dev/null
    bind -M insert --erase $CLAUDE_AI_BIND_COMPLETE 2>/dev/null
    bind -M insert --erase $CLAUDE_AI_BIND_FIX 2>/dev/null
end

# Clean up global variables
set --erase CLAUDE_AI_BIND_TRANSFORM
set --erase CLAUDE_AI_BIND_COMPLETE
set --erase CLAUDE_AI_BIND_FIX
set --erase CLAUDE_AI_DISABLED
