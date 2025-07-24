#!/usr/bin/env bash

clear
function find_file_view() {
       FILE_NAME=$1
       git log "*/${FILE_NAME}" 2>/dev/null | cut -d" " -f 2  | grep -E '^[0-9a-f]{40}$' | \
       fzf --ansi --no-sort --reverse --tiebreak=index --preview \
       'f() { set -- $(echo -- "$@" | grep -o "[a-f0-9]\{7\}"); [ $# -eq 0 ] || git log --stat --color=always -n 1 $1 ; }; f {}' \
       --bind "ctrl-y:execute:echo {} | grep -o '[a-f0-9]\{7\}' | head -1 | tr -d '\n' | pbcopy"\
       --bind "j:preview-down,k:preview-up,J:preview-page-down,K:preview-page-up,ctrl-j:down,ctrl-k:up,q:abort"\
       --bind "ctrl-o:execute:
                    (grep -o '[a-f0-9]\{7\}' | head -1 |
                    xargs -I % sh -c 'git show --color=always % | less -R') << 'FZF-EOF'
                    {}
        FZF-EOF" \
        --preview-window=right:80%
}

find_file_view "$@"

# Uncomment the following line to use icdiff instead of less for diff viewing, but this command has input error
# --bind "ctrl-o:become:(grep -o '[a-f0-9]\{7\}' | head -1 | xargs -I % git icdiff %) << 'FZF-EOF'
#              {}
#  FZF-EOF" \
