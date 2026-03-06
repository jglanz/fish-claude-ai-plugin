function claude_ai_complete --description "Generate command completions via Claude Code, select with fzf"
    set -l buf (commandline -b | string trim)

    # On empty buffer after a failure, delegate to fix
    if test -z "$buf"
        claude_ai_fix
        return $status
    end

    set -l spinner_pid ""
    if isatty stderr
        fish -c 'while true; for c in ⠋ ⠙ ⠹ ⠸ ⠼ ⠴ ⠦ ⠧ ⠇ ⠏; echo -ne "\r$c Claude..." >&2; sleep 0.1; end; end' &
        set spinner_pid $last_pid
    end

    set -l result (claude -p "You are a fish shell assistant on "(uname -s)". Given this partial input, suggest 5 possible complete commands. Output ONLY the commands, one per line. No numbering, no markdown, no explanation. Partial input: $buf" 2>/dev/null | string trim)

    if test -n "$spinner_pid"
        kill $spinner_pid 2>/dev/null
        echo -ne "\r\033[K" >&2
    end

    if test -z "$result"
        echo -e "\r\033[Kclaude_ai: no completions returned" >&2
        commandline -f repaint
        return 1
    end

    # Strip any markdown fences
    set result (echo $result | string replace -r '^```(?:fish|bash|sh)?\s*' '' | string replace -r '\s*```$' '')

    if command -q fzf
        set -l selection (echo $result | fzf --height=10 --layout=reverse --border --prompt="  " --no-info)
        if test -n "$selection"
            commandline -r $selection
        end
    else
        # Fallback: use the first suggestion
        set -l first_line (echo $result | head -1 | string trim)
        if test -n "$first_line"
            commandline -r $first_line
        end
    end

    commandline -f repaint
end
