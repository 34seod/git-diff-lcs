# frozen_string_literal: true

require "git_diff_lcs/shortstat"
require "git_diff_lcs/constants"
require "git_diff_lcs/cli"
require "git_diff_lcs/lib_git"

# Git Diff LCS
module GitDiffLCS
  # Get diff --shortstat with LCS algorithm
  #
  # Arguments:
  #   [String] git_target: git repository address or working directory
  #   [String] src: commit or branch
  #   [String] dest: commit or branch
  #
  # Return:
  #   [String] diff summary (changed files, insertions, deletions, modifications and total)
  #
  # Example:
  #   >> GitDiffLCS.shortstat("https://github.com/btpink-seo/git-diff-lcs.git", "test/src", "test/dest")
  #   => 5 files changed, 13 insertions(+), 6 deletions(-), 2 modifications(!), total(21)
  def self.shortstat(git_target, src, dest)
    shortstat = GitDiffLCS::Shortstat.new(git_target, src, dest)
    shortstat.errors.empty? ? shortstat.summary : shortstat.errors.first
  end
end
