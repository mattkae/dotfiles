#!/bin/bash

# 1. Sync with remote
git fetch --all --prune

# 2. Identify the default branch (e.g., main or master)
BASE=$(git symbolic-ref --short refs/remotes/origin/HEAD | sed 's@^origin/@@')

# 3. Switch to it and update
git checkout "$BASE"
git pull

# 4. Delete local branches that have been merged into BASE
# Added the | after --merged and included $BASE in the exclusion list
git branch --merged | \
    grep -vE "^\s*(\*|main|develop|master|$BASE)" | \
    xargs -r -n 1 git branch -d
