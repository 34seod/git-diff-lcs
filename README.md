# git-diff-lsc

Generally, git diff --stat does not contain modifications, so we added it to display modifications using the LCS algorithm.

# How to use
```
$ gem install git_diff_lcs
```

```ruby
require 'git_diff_lcs'

GitDiffLcs.diff('https://github.com/halostatue/diff-lcs.git', 'ee246c0924f0d1fa0d1be0a5503215da7f15903f', 'main')
```
