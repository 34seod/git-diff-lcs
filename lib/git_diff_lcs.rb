# frozen_string_literal: true

require "git_diff_lcs/stat"
require "git_diff_lcs/version"
require "git_diff_lcs/cli"

# Git Diff LCS
module GitDiffLCS
  # Get diff summary with LCS algorithm
  #
  # Arguments:
  #   [String] repo: repo git repository address
  #   [String] src: src src commit or branch
  #   [String] dest: dest commit or branch
  #
  # Return:
  #   [String] diff summary (changed files, insertions, deletions, modifications and total)
  #
  # Example:
  #   >> GitDiffLCS.diff("https://github.com/btpink-seo/git-diff-lcs.git", "test/src", "test/dest")
  #   => 5 files changed, 13 insertions(+), 6 deletions(-), 2 modifications(!), total(21)
  def self.diff(repo, src, dest)
    diff = GitDiffLCS::Stat.new(repo, src, dest)
    diff.errors.empty? ? diff.summary : diff.errors.first
  end
end
