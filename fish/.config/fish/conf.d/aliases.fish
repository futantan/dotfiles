alias cz=git-cz
alias dev='npm run dev'
alias gcmsg='git commit -m'
alias ll='exa -l -g --icons'
alias lla='ll -a'
alias o='open .'
alias p=pnpm
alias q=exit

alias sshdokploy='ssh root@100.65.70.118'
alias sshellie='ssh root@100.79.196.58'
alias nuke="git reset --hard HEAD; and git clean -df"
alias c="claude --dangerously-skip-permissions"

function codex-review-json --description "Review uncommitted changes with Codex and print JSON"
    if not git rev-parse --is-inside-work-tree >/dev/null 2>/dev/null
        echo '{"passed":false,"actions":["Not inside a git repository."]}'
        return 1
    end

    set -l changes (git status --short --untracked-files=all)
    if test (count $changes) -eq 0
        echo '{"passed":true,"actions":null}'
        return 0
    end

    set -l tmpdir (mktemp -d)
    if test $status -ne 0
        echo '{"passed":false,"actions":["Failed to create a temporary directory."]}'
        return 1
    end

    set -l schema_file "$tmpdir/schema.json"
    set -l output_file "$tmpdir/output.json"
    set -l prompt "Review only the current git repository's uncommitted changes, including staged, unstaged, and untracked files. Focus on bugs, regressions, missing tests, unsafe behavior, and maintainability issues worth fixing before commit. Return JSON only. Set passed to true and actions to null when the changes are ready. Otherwise set passed to false and actions to a concise array of specific improvements."

    begin
        echo '{'
        echo '  "$schema": "http://json-schema.org/draft-07/schema#",'
        echo '  "type": "object",'
        echo '  "additionalProperties": false,'
        echo '  "required": ["passed", "actions"],'
        echo '  "properties": {'
        echo '    "passed": { "type": "boolean" },'
        echo '    "actions": {'
        echo '      "anyOf": ['
        echo '        { "type": "null" },'
        echo '        { "type": "array", "items": { "type": "string" } }'
        echo '      ]'
        echo '    }'
        echo '  }'
        echo '}'
    end > $schema_file

    codex exec \
        --cd (pwd) \
        --sandbox read-only \
        --skip-git-repo-check \
        --ephemeral \
        --output-schema $schema_file \
        --output-last-message $output_file \
        "$prompt" >/dev/null 2>/dev/null

    set -l codex_status $status
    if test $codex_status -ne 0
        command rm -rf $tmpdir
        echo '{"passed":false,"actions":["Codex review failed."]}'
        return $codex_status
    end

    if test -f $output_file
        cat $output_file
        command rm -rf $tmpdir
        return 0
    end

    command rm -rf $tmpdir
    echo '{"passed":false,"actions":["Codex did not return a result."]}'
    return 1
end

alias crj='codex-review-json'
