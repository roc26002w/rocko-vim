#!/bin/sh

# 將專案的 openspec 規範同步到 ai-tools/openspec，供各 AI 工具參考。
#
# 用法
#   sync-openspec.sh                     同步，保護本地較新的編輯
#   sync-openspec.sh --dry-run           預覽（受 --update 影響，看不到落後的檔案）
#   sync-openspec.sh --dry-run --force   檢查有無差異，不寫入 ← 稽核用
#   sync-openspec.sh --force             強制以來源覆蓋
#   sync-openspec.sh ~/其他/repo          換來源（預設 ~/code/novax/novax-netask-web）
#
# 底層為 rsync -a --update，只處理 *.md，遞迴子目錄；
# 來源缺少的 spec 會標 ? 跳過而非中斷。
#
#   --update       目標端較新的檔案不覆蓋，保住手動編輯
#   不用 --delete  目標端額外新增的檔案會保留
#
# 注意：--update 會讓落後的檔案「靜默跳過」，畫面顯示「全部一致」時，
#       分不出是真的一致還是被跳過。要確認就跑 --dry-run --force：
#       有列出檔案即代表與來源有差異（你的手動編輯，或你落後了）。
#
# 同名檔案以來源為準；想保留的自訂內容請放獨立檔名（如 xxx/my-notes.md）。
# 新增要同步的 spec 時，只需在下方 SPECS 加一行。

set -e

SRC_REPO="$HOME/code/novax/novax-netask-web"
DRY_RUN=""
UPDATE="--update"

for arg in "$@"; do
    case "$arg" in
        -n|--dry-run) DRY_RUN="--dry-run" ;;
        -f|--force) UPDATE="" ;;
        -*) echo "未知選項: $arg" >&2; exit 1 ;;
        *) SRC_REPO="$arg" ;;
    esac
done

SRC="$SRC_REPO/openspec/specs"
DST="$(cd "$(dirname "$0")" && pwd)/openspec"

SPECS="
app-service-pattern
code-comment-convention
commit-convention
controller-refactor-pattern
tdd-pattern
"

if [ ! -d "$SRC" ]; then
    echo "找不到來源目錄: $SRC" >&2
    echo "用法: $(basename "$0") [來源 repo 路徑] [--dry-run] [--force]" >&2
    exit 1
fi

[ -n "$DRY_RUN" ] && echo "（--dry-run：僅顯示異動，不實際寫入）"
[ -z "$UPDATE" ] && echo "（--force：忽略目標端較新的檔案，一律以來源覆蓋）"

changed=0
missing=0

for name in $SPECS; do
    if [ ! -d "$SRC/$name" ]; then
        printf '  ?  %s（來源不存在，跳過）\n' "$name"
        missing=$((missing + 1))
        continue
    fi

    [ -n "$DRY_RUN" ] || mkdir -p "$DST/$name"

    out="$(rsync -a $UPDATE $DRY_RUN \
        --include='*/' --include='*.md' --exclude='*' \
        --out-format="%i|$name/%n" \
        "$SRC/$name/" "$DST/$name/")"

    [ -n "$out" ] || continue

    # %i 第 2 碼為 d 代表目錄項目，不列出
    printf '%s\n' "$out" | awk -F'|' '
        substr($1, 2, 1) == "d" { next }
                                { printf "  +  %s\n", $2 }
    '

    n="$(printf '%s\n' "$out" | awk -F'|' '
        substr($1, 2, 1) == "d" { next }
                                { c++ }
        END { print c + 0 }
    ')"
    changed=$((changed + n))
done

[ "$changed" -eq 0 ] && echo "  =  全部一致，無異動"

echo
echo "來源: $SRC"
echo "目標: $DST"
echo "異動 $changed 檔，缺少 $missing 個 spec"
