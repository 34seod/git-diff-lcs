# GitDiffLcs

Generally, git diff --stat does not contain modifications, so we added it to display modifications using the LCS algorithm.

## Installation
```bash
$ gem install git_diff-lcs
```

## How to use
```ruby
require 'git_diff_lcs'

GitDiffLcs.diff('https://github.com/btpink-seo/git-diff-lcs.git', 'main', 'gem')
# => 169 files changed, 10407 insertions(+), 84 deletions(-), 134 modifications(!), total(10625)
```
