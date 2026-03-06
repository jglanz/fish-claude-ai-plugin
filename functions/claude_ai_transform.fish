function claude_ai_transform --description "Smart transform: comment→command or command→explanation"
    set -l buf (commandline -b | string trim)

    if test -z "$buf"
        return 1
    end

    # If buffer starts with '#', treat as natural language → generate command
    # Otherwise, treat as command → generate explanation
    if string match -qr '^\s*#' -- $buf
        claude_ai_cmd
    else
        claude_ai_explain
    end
end
