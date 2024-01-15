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
  cd ${dir} && git checkout -- ./ && git checkout develop
  git pull 
  cd ..
done
exit

