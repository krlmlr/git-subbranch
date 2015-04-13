#!/bin/sh

set -e
set -x

rm -rf test
mkdir test
cd test

. functions

# Init repo
git init .
git commit --allow-empty -m "initial"

# Add contents
echo "# README" > README.md
echo >> README.md
echo "Some text" >> README.md
git add README.md
git commit -m "add README"

git_subbranch_ignore

git_subbranch_init

# Display branches
git branch -vv
git log --graph --oneline --all

# Deploy something to gh-pages
tac README.md > gh-pages-dir/README.dm

# Update gh-pages
cd gh-pages-dir
git fetch
git merge -s ours origin/master --no-edit
git add README.dm
git commit --amend -m "deploy"
git push -u -f origin gh-pages
cd ..

# Display branches again
git branch -vv
git log --graph --oneline --all

# Edit
echo "More stuff" >> README.md
git add README.md
git commit -m "More stuff"

echo "Even more stuff" >> README.md
git add README.md
git commit -m "Even more stuff"

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

# Display branches
git branch -vv
git log --graph --oneline --all

# Display contents
cat README.md
cat gh-pages-dir/README.dm
