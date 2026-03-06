function claude_ai_cmd --description "Convert natural language comment to a shell command via Claude Code"
    set -l buf (commandline -b | string trim)

    if test -z "$buf"
        return 1
    end

    # Strip leading '#' if present
    set -l prompt (string replace -r '^\s*#\s*' '' -- $buf)

    set -l spinner_pid ""
    if isatty stderr
        fish -c 'while true; for c in ⠋ ⠙ ⠹ ⠸ ⠼ ⠴ ⠦ ⠧ ⠇ ⠏; echo -ne "\r$c Claude..." >&2; sleep 0.1; end; end' &
        set spinner_pid $last_pid
    end

    set -l result (claude -p "You are a fish shell command generator running on "(uname -s)". Output ONLY the raw shell command. No markdown, no backticks, no explanation. Task: $prompt" 2>/dev/null | string trim)

    if test -n "$spinner_pid"
        kill $spinner_pid 2>/dev/null
        echo -ne "\r\033[K" >&2
    end

    if test -n "$result"
        # Strip markdown fences if the model leaks them
        set result (echo $result | string replace -r '^```(?:fish|bash|sh)?\s*' '' | string replace -r '\s*```$' '')
        commandline -r $result
        commandline -f repaint
    else
        echo -e "\r\033[Kclaude_ai: no response from Claude Code" >&2
        commandline -f repaint
    end
end
