# git-diff-lsc

Generally, git diff --stat does not contain modifications, so we added it to display modifications using the LCS algorithm.

# How to use
```
$ gem install diff-lcs
$ gem install git
$ ruby diff_git_clone.rb [git repository address] [src branch or commit] [dest branch or commit]
=> 169 files changed, 10407 insertions(+), 84 deletions(-), 134 modifications(!), total(10625)
```
