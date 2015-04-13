#!/bin/sh

set -e
set -x

. ./functions

rm -rf test
mkdir test
cd test

# Init repo
git init .
git commit --allow-empty -m "initial"

# Add contents
help_edit_source "initial README.md"

# Create infrastructure (execute once)
git_subbranch_ignore
git_subbranch_init

# Show results -- unrelated branches
help_branch_display

# Write artifact to gh-pages
help_create_artifact

# Update gh-pages
git_subbranch_commit
git_subbranch_push

# Show results -- gh-pages branch now has parent as master
help_branch_display

# Edit
help_edit_source "More stuff"
help_edit_source "Even more stuff"

# Deploy to gh-pages again
tac README.md > gh-pages-dir/README.dm

# Update gh-pages
cd gh-pages-dir
git fetch
git merge -s ours origin/master --no-edit
git add README.dm
git commit --amend -m "deploy"
git push -u -f origin gh-pages
cd ..

help_branch_display

# Display contents
cat README.md
cat gh-pages-dir/README.dm
