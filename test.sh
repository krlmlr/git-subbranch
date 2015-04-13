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

# Write artifact to gh-pages again
help_create_artifact

# Update gh-pages
git_subbranch_commit

# Oh, forgot!
help_edit_source "Oops, forgot"

# Write artifact to gh-pages again
help_create_artifact

# Update gh-pages
git_subbranch_commit

# Ready? Go!
git_subbranch_push

# Still everything nice and in order
help_branch_display

# List files
ls
ls gh-pages-dir

# No README.md file in gh-pages
! ls gh-pages-dir/README.md

# Display contents
cat README.md
cat gh-pages-dir/README.dm

# README.dm is the reverse of README.md
tac README.md | diff - gh-pages-dir/README.dm
