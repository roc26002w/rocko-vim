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
for dir in $(ls -al | grep -E "netask-cloud|novax|laravel|hrms" | grep -v "v96" | awk '{print $9}'); do
  echo "patch ${dir}"
  cd ${dir} 
  DIFF_EXISTS=$(git status --porcelain | wc -l)
  if [[ $DIFF_EXISTS -eq 0 ]]
  then
    # git checkout develop
    echo "no file changes"
  else
    git add . && git stash save "draft commit"
  fi
  
  # update first default branch
  BRANCH=$(git branch | cut -c3- | grep 'main\|master\|develop' | head -n 1)
  git checkout ${BRANCH}
  git pull
  cd ..
done
exit

# update locale all branch
# for branch in $(git branch | awk -F ' +' '! /\(no branch\)/ {print $2}'); do
#   echo "fetch branch is : ${branch}"
#   git checkout ${branch}
#   git pull
# done

