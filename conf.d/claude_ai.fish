# claude_ai.fish — key bindings for plugin-claude-ai
# Loaded automatically by fish via conf.d/ (Fisher) or init.fish (OMF)

if not set -q CLAUDE_AI_DISABLED

    # Configurable key bindings (override via environment before shell init)
    set -q CLAUDE_AI_BIND_TRANSFORM; or set -g CLAUDE_AI_BIND_TRANSFORM \cp       # Ctrl+P
    set -q CLAUDE_AI_BIND_FIX;       or set -g CLAUDE_AI_BIND_FIX \cx            # Ctrl+X
    # set -q CLAUDE_AI_BIND_COMPLETE;  or set -g CLAUDE_AI_BIND_COMPLETE \c\x20       # Ctrl+Space (^@)

    bind $CLAUDE_AI_BIND_TRANSFORM claude_ai_transform
    bind $CLAUDE_AI_BIND_FIX       claude_ai_fix
    # bind $CLAUDE_AI_BIND_COMPLETE  claude_ai_complete

    # Also bind for vi insert mode if vi key bindings are active
    if test "$fish_key_bindings" = fish_vi_key_bindings
        bind -M insert $CLAUDE_AI_BIND_TRANSFORM claude_ai_transform
        bind -M insert $CLAUDE_AI_BIND_FIX       claude_ai_fix
        # bind -M insert $CLAUDE_AI_BIND_COMPLETE  claude_ai_complete
    end
end
