#!/bin/bash
if [ -z "$2" ]; then
  git difftool -y "${1}" "${1}~1"  # diff against previous commit
else
  git difftool -y "${1}" "${1}~1" -- "$2"  # filebased diff against previous
fi
