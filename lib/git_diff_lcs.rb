# frozen_string_literal: true

require "git_diff_lcs/stat"
require "git_diff_lcs/version"

# git diff lcs
module GitDiffLcs
  def self.hi
    puts "hi23"
  end

  def self.diff(repo, src, dest)
    dir = Dir.mktmpdir
    # DiffWithModification.new
    # param1(String) : directory for clone
    # param2(String) : git address
    # param3(String) : src commit
    # param4(String) : dest commit
    diff = GitDiffLcs::Stat.new(dir, repo, src, dest)
    FileUtils.rm_rf(dir)
    diff.summary
  end
end
