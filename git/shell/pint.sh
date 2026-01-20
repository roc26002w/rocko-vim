#!/usr/bin/env bash

# This script is sample for laravel pint code formatter to select config
# 獲取未暫存的檔案
#not_staged_files=$(git diff --name-only)

# 獲取未追蹤的檔案
untracked_files=$(git ls-files --others --exclude-standard)

# 獲取已暫存的檔案
staged_files=$(git diff --cached --name-only)

combined_files="$staged_files"$'\n'"$untracked_files"

echo $combined_files | xargs pint

