#!/bin/bash

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title Update Netask Cloud Project
# @raycast.mode fullOutput

# Optional parameters:
# @raycast.icon 🤖

# Documentation:
# @raycast.description Update Netask Cloud Project
# @raycast.author roc26002w
# @raycast.authorURL https://raycast.com/roc26002w

cd ~/code/novax
for dir in $(ls -al | grep netask-cloud | awk '{print $9}'); do
  echo "patch ${dir}"
  cd ${dir} 
  DIFF_EXISTS=$(git status --porcelain | wc -l)
  if [[ $DIFF_EXISTS -eq 0 ]]
  then
    git checkout develop
  else
    git add . && git stash save "draft commit" && git checkout develop
  fi
  git pull 
  cd ..
done
exit
