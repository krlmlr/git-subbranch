---
layout: index
---

# git-subbranch [![Build Status](https://travis-ci.org/krlmlr/git-subbranch.svg?branch=master)](https://travis-ci.org/krlmlr/git-subbranch)

This may be of interest for you if you host project pages in a GitHub Pages branch (or in a similar setup) and need to derive the contents of the branch from the project itself (e.g., artifacts, documentation, ...).

## The problem

The `gh-pages` branch in GitHub is special -- its contents are interpreted as a Jekyll or HTML website and provided on http://username.github.io/projectname.  The source files, on the other hand, are supposed to be located in another branch, e.g., `master`, with possible further feature/hotfix/... branches.  If the contents of the `gh-pages` branch depend on the contents of the "main" branches, there are several obvious options for organizing this:

1. Switching between branches: One checkout, current branch is chosen via `git checkout`.
2. Side by side: Two checkouts, but with different checked-out branches. (@chrisjacob [discusses](https://gist.github.com/chrisjacob/833223) a setup using a "grand-parent" directory.)
3. Contents of the `gh-pages` branch are contained redundantly in a subdirectory. (Uses `git subtree`, described [here](https://gist.github.com/cobyism/4730490), [here](http://gsferreira.com/archive/2014/06/update-github-pages-using-a-project-subfolder/), [here](http://lukecod.es/2014/08/15/deploy-a-static-subdirectory-to-github-pages/), [here](http://happygiraffe.net/blog/2009/07/04/publishing-a-subdirectory-to-github-pages/), and [my favorite approach until now](https://github.com/johnmyleswhite/ProjectTemplate/blob/9374ccc80066f48c925a8e67f159b6602da7c3e8/Makefile#L9)).

None of them are really satisfactory. Perhaps this can be done better.


## Proposition

- Clone the `gh-pages` branch into a subdirectory, say, `gh-pages-dir`
- Ignore this subdirectory via `.gitignore`
- Initial state of the `gh-pages` branch is an orphaned branch, completely unrelated to all other branches
- For deployment, first a merge from `master` is performed in order to connect the histories.  (This step is optional but could be desirable.)
- Commits to `gh-pages` can be performed by `cd`-ing to `gh-pages-dir` and performing regular `git` operation
- The main checkout is set as the `origin` remote of the `gh-pages-dir` sub-repository. This avoids any remote access for preparing a deployment, a `git push` in the main checkout updates both regular and the `gh-pages` branches


## Demonstration

```
make[1]: Entering directory '/home/muelleki/git/git-subbranch'
rm -rf /tmp/git-subbranch
cp -r . /tmp/git-subbranch
cd /tmp/git-subbranch && make test
make[2]: Entering directory '/tmp/git-subbranch'
./test.sh
Initialized empty Git repository in /tmp/git-subbranch/test/.git/
[master (root-commit) b15eca6] initial
[master a7aac67] initial README.md
 1 file changed, 1 insertion(+)
 create mode 100644 README.md
[master ddf61f1] ignore gh-pages-dir
 1 file changed, 1 insertion(+)
 create mode 100644 .gitignore
[gh-pages (root-commit) 4ff97d2] initial (pages)
Deleted branch master (was ddf61f1).
Branch gh-pages set up to track remote branch gh-pages from origin.
  gh-pages 4ff97d2 initial (pages)
* master   ddf61f1 ignore gh-pages-dir
* 4ff97d2 initial (pages)
* ddf61f1 ignore gh-pages-dir
* a7aac67 initial README.md
* b15eca6 initial
Merge made by the 'ours' strategy.
[gh-pages 87132ee] deploy
 1 file changed, 1 insertion(+)
 create mode 100644 README.dm
Branch gh-pages set up to track remote branch gh-pages from origin.
  gh-pages 87132ee deploy
* master   ddf61f1 ignore gh-pages-dir
* 87132ee deploy
*   3708b2b Merge remote-tracking branch 'origin/master' into gh-pages
|\  
| * ddf61f1 ignore gh-pages-dir
| * a7aac67 initial README.md
| * b15eca6 initial
* 4ff97d2 initial (pages)
[master 0387705] More stuff
 1 file changed, 1 insertion(+)
[master 3d7626b] Even more stuff
 1 file changed, 1 insertion(+)
Merge made by the 'ours' strategy.
[gh-pages c13de65] deploy
 1 file changed, 2 insertions(+)
[master 3158523] Oops, forgot
 1 file changed, 1 insertion(+)
Merge made by the 'ours' strategy.
[gh-pages d4028b5] deploy
 1 file changed, 1 insertion(+)
Branch gh-pages set up to track remote branch gh-pages from origin.
  gh-pages d4028b5 deploy
* master   3158523 Oops, forgot
* d4028b5 deploy
*   9d17ee9 Merge remote-tracking branch 'origin/master' into gh-pages
|\  
| * 3158523 Oops, forgot
* | c13de65 deploy
* |   d8a6ccf Merge remote-tracking branch 'origin/master' into gh-pages
|\ \  
| |/  
| * 3d7626b Even more stuff
| * 0387705 More stuff
* | 87132ee deploy
* |   3708b2b Merge remote-tracking branch 'origin/master' into gh-pages
|\ \  
| |/  
| * ddf61f1 ignore gh-pages-dir
| * a7aac67 initial README.md
| * b15eca6 initial
* 4ff97d2 initial (pages)
gh-pages-dir
README.md
README.dm
initial README.md
More stuff
Even more stuff
Oops, forgot
Oops, forgot
Even more stuff
More stuff
initial README.md
make[2]: Leaving directory '/tmp/git-subbranch'
make[1]: Leaving directory '/home/muelleki/git/git-subbranch'
```


## Documentation

The file [`functions`](https://github.com/krlmlr/git-subbranch/blob/master/functions) defines a few verbs, the interesting ones have a with `git_subbranch_` prefix:

- `ignore`: Is supposed to run only once, adds the `gh-pages-dir` to `.gitignore`.
- `init`: Initializes a `gh-pages` branch, sets up the repository for this branch in `gh-pages-dir` and links this repository to the main checkout.
- `link`: Links the current state of the `master` branch with the `gh-pages` branch (a tricky `git merge`).
- `commit`: Commits all files in `gh-pages-dir` (just a `git add -A`).
- `push`: Updates the local `gh-pages` branch from the repository in `gh-pages-dir`.

In day-to-day use, the usual sequence of commands will be `link` -> `commit` -> `push`, although they can be interchanged arbitrarily.  In particular, if you never `link`, the two branches remain completely separate.


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


## Summary

The setup described here seems to work for me, although this site (and the commands presented here) is in a very early stage.  I hope others find this useful too, and this sketch evolves into a more mature tool.
