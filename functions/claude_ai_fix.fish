function claude_ai_fix --description "Fix the last failed command via Claude Code"
    set -l last_cmd (history --max 1)

    if test -z "$last_cmd"
        echo "claude_ai: no command in history to fix" >&2
        return 1
    end

    set -l spinner_pid ""
    if isatty stderr
        fish -c 'while true; for c in ⠋ ⠙ ⠹ ⠸ ⠼ ⠴ ⠦ ⠧ ⠇ ⠏; echo -ne "\r$c Claude..." >&2; sleep 0.1; end; end' &
        set spinner_pid $last_pid
    end

    set -l result (claude -p "You are a fish shell command fixer on "(uname -s)". The following command failed. Output ONLY the corrected command, no markdown, no backticks, no explanation. Failed command: $last_cmd" 2>/dev/null | string trim)

    if test -n "$spinner_pid"
        kill $spinner_pid 2>/dev/null
        echo -ne "\r\033[K" >&2
    end

    if test -n "$result"
        set result (echo $result | string replace -r '^```(?:fish|bash|sh)?\s*' '' | string replace -r '\s*```$' '')
        commandline -r $result
        commandline -f repaint
    else
        echo -e "\r\033[Kclaude_ai: no response from Claude Code" >&2
        commandline -f repaint
    end
end
