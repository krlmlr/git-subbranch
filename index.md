---
layout: index
---

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

```
make[1]: Entering directory '/home/muelleki/git/git-subbranch'
rm -rf /tmp/git-subbranch
cp -r . /tmp/git-subbranch
cd /tmp/git-subbranch && make test
make[2]: Entering directory '/tmp/git-subbranch'
./test.sh
Initialized empty Git repository in /tmp/git-subbranch/test/.git/
[master (root-commit) 34332aa] initial
[master 6fa3e83] initial README.md
 1 file changed, 1 insertion(+)
 create mode 100644 README.md
[master 21c17fb] ignore gh-pages-dir
 1 file changed, 1 insertion(+)
 create mode 100644 .gitignore
[gh-pages (root-commit) ce6ace1] initial (pages)
Deleted branch master (was 21c17fb).
Branch gh-pages set up to track remote branch gh-pages from origin.
  gh-pages ce6ace1 initial (pages)
* master   21c17fb ignore gh-pages-dir
* ce6ace1 initial (pages)
* 21c17fb ignore gh-pages-dir
* 6fa3e83 initial README.md
* 34332aa initial
Merge made by the 'ours' strategy.
[gh-pages 2dec730] deploy
 1 file changed, 1 insertion(+)
 create mode 100644 README.dm
Branch gh-pages set up to track remote branch gh-pages from origin.
  gh-pages 2dec730 deploy
* master   21c17fb ignore gh-pages-dir
* 2dec730 deploy
*   a488b7e Merge remote-tracking branch 'origin/master' into gh-pages
|\  
| * 21c17fb ignore gh-pages-dir
| * 6fa3e83 initial README.md
| * 34332aa initial
* ce6ace1 initial (pages)
[master 2a3135f] More stuff
 1 file changed, 1 insertion(+)
[master 7b9f5a2] Even more stuff
 1 file changed, 1 insertion(+)
Merge made by the 'ours' strategy.
[gh-pages bbe348a] deploy
 1 file changed, 2 insertions(+)
[master 04dff07] Oops, forgot
 1 file changed, 1 insertion(+)
Merge made by the 'ours' strategy.
[gh-pages 5ca35af] deploy
 1 file changed, 1 insertion(+)
Branch gh-pages set up to track remote branch gh-pages from origin.
  gh-pages 5ca35af deploy
* master   04dff07 Oops, forgot
* 5ca35af deploy
*   4e8c963 Merge remote-tracking branch 'origin/master' into gh-pages
|\  
| * 04dff07 Oops, forgot
* | bbe348a deploy
* |   b1bc593 Merge remote-tracking branch 'origin/master' into gh-pages
|\ \  
| |/  
| * 7b9f5a2 Even more stuff
| * 2a3135f More stuff
* | 2dec730 deploy
* |   a488b7e Merge remote-tracking branch 'origin/master' into gh-pages
|\ \  
| |/  
| * 21c17fb ignore gh-pages-dir
| * 6fa3e83 initial README.md
| * 34332aa initial
* ce6ace1 initial (pages)
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
