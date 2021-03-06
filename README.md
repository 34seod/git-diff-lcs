# GitDiffLcs

Generally, git diff --stat does not contain modifications, so we added it to display modifications using the LCS algorithm.

## Installation
```bash
$ gem install git_diff-lcs
```

## How to use

### diff(repo, src, dest)

src, dest is branch name or commit

example
```ruby
require 'git_diff_lcs'

GitDiffLcs.diff('https://github.com/btpink-seo/git-diff-lcs.git', 'test/src', 'test/dest')
# => 5 files changed, 13 insertions(+), 6 deletions(-), 2 modifications(!), total(21)
```
