# GitDiffLcs

Generally, git diff --stat does not contain modifications, so we added it to display modifications using the LCS algorithm.

## Installation
```bash
$ gem install git_diff-lcs
```

## How to use

### CLI

```bash
$ git_diff_lcs diff https://github.com/btpink-seo/git-diff-lcs.git test/src test/dest
```

### Ruby

#### diff(repo, src, dest)

src, dest is branch name or commit

```ruby
require 'git_diff_lcs'

GitDiffLcs.diff('https://github.com/btpink-seo/git-diff-lcs.git', 'test/src', 'test/dest')
# => 5 files changed, 13 insertions(+), 6 deletions(-), 2 modifications(!), total(21)
```

#### GitDiffLcs::Stat.new(repo, src, dest)

```ruby
require 'git_diff_lcs'

stat = GitDiffLcs::Stat.new('https://github.com/btpink-seo/git-diff-lcs.git', 'test/src', 'test/dest')
stat.summary
# => 5 files changed, 13 insertions(+), 6 deletions(-), 2 modifications(!), total(21)
stat.insertions
# => 13
stat.deletions
# => 6
stat.modifications
# => 2
```
