#!/usr/bin/env bash

# This script is sample for git fsck view to fetch drop stash hash and copy to clipboard
#
# [git config sample](https://git.tsundere.moe/Frederick888/frederick-settings/blob/master/.gitconfig)
# [git spnnipets gist](https://gist.github.com/junegunn/f4fca918e937e6bf5bad)
#
# git log --graph --color=always --format="%C(auto)%h%d %s %C(black)%C(bold)%cr" "$@"
# git fsck --no-reflog 2>/dev/null | grep "dangling commit" | cut -d" " -f 3 |  xargs -I "{}" git --no-pager show --no-patch --format="%C(auto)%h %ai %C(auto)<%an> %C(black)%C(bold)%s%n" "{}" |

function fsck_view() {
       git fsck --no-reflog 2>/dev/null | grep "dangling commit" | cut -d" " -f 3  | \
       fzf --ansi --no-sort --reverse --tiebreak=index --preview \
       'f() { set -- $(echo -- "$@" | grep -o "[a-f0-9]\{7\}"); [ $# -eq 0 ] || git show --color=always $1 ; }; f {}' \
       --bind "ctrl-y:execute:echo {} | grep -o '[a-f0-9]\{7\}' | head -1 | pbcopy"\
       --bind "j:preview-down,k:preview-up,J:preview-page-down,K:preview-page-up,ctrl-j:down,ctrl-k:up,q:abort"\
       --bind "ctrl-o:execute:
                    (grep -o '[a-f0-9]\{7\}' | head -1 |
                    xargs -I % sh -c 'git show --color=always % | less -R') << 'FZF-EOF'
                    {}
        FZF-EOF" \
        --preview-window=right:60%
}

fsck_view
