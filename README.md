# GitDiffLCS

Generally, git diff --stat does not contain modifications, so we added it to display modifications using the LCS algorithm.

## Installation
```bash
$ gem install git_diff-lcs
```

## How to use

```bash
$ git_diff_lcs shortstat  [GIT_REPOSITORY or WORKING_DIRECTORY] [SRC(branch or commit)] [DEST(branch or commit)]
$ git_diff_lcs shortstat  https://github.com/btpink-seo/git-diff-lcs.git test/src test/dest
$ git_diff_lcs shortstat  workspace/git-diff-lcs test/src test/dest
```

## compare with git diff

```bash
$ git diff --shortstat test/src test/dest
 5 files changed, 15 insertions(+), 8 deletions(-)

$ git_diff_lcs shortstat https://github.com/btpink-seo/git-diff-lcs.git test/src test/dest
 5 files changed, 13 insertions(+), 6 deletions(-), 2 modifications(!), total(21)
```
