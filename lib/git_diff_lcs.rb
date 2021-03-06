# frozen_string_literal: true

require "git_diff_lcs/stat"
require "git_diff_lcs/version"

# git diff lcs
module GitDiffLcs
  def self.diff(repo, src, dest)
    diff = GitDiffLcs::Stat.new(repo, src, dest)
    diff.summary
  end
end
