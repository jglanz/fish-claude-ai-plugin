function claude_ai_explain --description "Explain the current command line buffer via Claude Code"
    set -l buf (commandline -b | string trim)

    if test -z "$buf"
        return 1
    end

    set -l spinner_pid ""
    if isatty stderr
        fish -c 'while true; for c in ⠋ ⠙ ⠹ ⠸ ⠼ ⠴ ⠦ ⠧ ⠇ ⠏; echo -ne "\r$c Claude..." >&2; sleep 0.1; end; end' &
        set spinner_pid $last_pid
    end

    set -l result (claude -p "Briefly explain this shell command in 1-3 sentences. No markdown. Command: $buf" 2>/dev/null | string trim)

    if test -n "$spinner_pid"
        kill $spinner_pid 2>/dev/null
        echo -ne "\r\033[K" >&2
    end

    if test -n "$result"
        echo >&2
        echo -e "\033[2m$result\033[0m" >&2
        commandline -f repaint
    else
        echo -e "\r\033[Kclaude_ai: no response from Claude Code" >&2
        commandline -f repaint
    end
end
