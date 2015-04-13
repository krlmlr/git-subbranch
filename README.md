# git-subbranch [![Build Status](https://travis-ci.org/krlmlr/git-subbranch.svg?branch=master)](https://travis-ci.org/krlmlr/git-subbranch)

This may be of interest for you if you host project pages in a GitHub Pages branch (or in a similar setup) and need to derive the contents of the branch from the project itself (e.g., artifacts, documentation, ...).

## The problem

The `gh-pages` branch in GitHub is special -- its contents are interpreted as a Jekyll or HTML website and provided on http://username.github.io/projectname.  The code, on the other hand, is supposed to be located in another branch, e.g., `master`, with possible further feature/hotfix/... branches.  If the contents of the `gh-pages` branch depend on the contents of the "main" branches, there are several obvious options for organizing this:

1. Switching between branches: One checkout, current branch is chosen via `git checkout`.
2. Side by side: Two checkouts, but with different checked-out branches. (@chrisjacob [discusses](https://gist.github.com/chrisjacob/833223) a setup using a "grand-parent" directory.)
3. Contents of the `gh-pages` branch are contained redundantly in a subdirectory. (Uses `git subtree`, described [here](https://gist.github.com/cobyism/4730490), [here](http://gsferreira.com/archive/2014/06/update-github-pages-using-a-project-subfolder/), [here](http://lukecod.es/2014/08/15/deploy-a-static-subdirectory-to-github-pages/), [here](http://happygiraffe.net/blog/2009/07/04/publishing-a-subdirectory-to-github-pages/), and [my favorite approach until now](https://github.com/johnmyleswhite/ProjectTemplate/blob/9374ccc80066f48c925a8e67f159b6602da7c3e8/Makefile#L9)).

Perhaps this can be done better.


## Proposition

- Clone the `gh-pages` branch into a subdirectory, say, `gh-pages-dir`
- Ignore this subdirectory via `.gitignore`
- Initial state of the `gh-pages` branch is an orphaned branch, completely unrelated to all other branches
- For deployment, first a merge from `master` is performed in order to connect the histories.  (This step is optional but could be desirable.)
- Commits to `gh-pages` can be performed by `cd`-ing to `gh-pages-dir` and performing regular `git` operation
- The main checkout is set as the `origin` remote of the `gh-pages-dir` sub-repository. This avoids any remote access for preparing a deployment, a `git push` in the main checkout updates both regular and the `gh-pages` branches


## Demonstration

Clone the repo and run `make`, a subdirectory `test` is created.  Or head over to the latest test result on [Travis CI](https://travis-ci.org/krlmlr/git-subbranch).


## Comparison

### To switching between branches

- Seamless operation
- No need to maintain a "clean" state of the repository just to look at the `gh-pages` branch
- Clear connection between regular and `gh-pages` branch via history (optional)


### To parallel structures

- Self-contained
- Clear connection between regular and `gh-pages` branch via history (optional)


### To redundant storage

- Separation of concern
- No waste of space
