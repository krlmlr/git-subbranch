#!/bin/sh

set -e
set -x

rm -rf test
mkdir test
cd test

# Init repo
git init .
git commit --allow-empty -m "initial"

# Add contents
echo "# README" > README.md
echo > README.md
echo "Some text" > README.md
git add README.md
git commit -m "add README"

# Ignore gh-pages-dir subdirectory
echo /gh-pages-dir >> .gitignore
git add .gitignore
git commit -m "ignore gh-pages-dir"

# Initialize fresh gh-pages branch
git clone . gh-pages-dir
cd gh-pages-dir
git checkout --orphan gh-pages
git commit --allow-empty -m "initial (pages)"
git branch -d master
git push -u origin gh-pages
cd ..

# Display branches
git branch -vv
git log --graph

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
git log --graph
