# frozen_string_literal: true

# $ gem install diff-lcs
# $ gem install git
# $ ruby core.rb https://github.com/btpink-seo/git-diff-lcs.git test/src test/dest

require "securerandom"
require "diff/lcs"
require "fileutils"
require "git"

# CORE
class DiffWithModification
  # Source folder
  SRC_FOLDER = "src_#{SecureRandom.uuid}"

  # Destination folder
  DEST_FOLDER = "dest_#{SecureRandom.uuid}"

  # Initial diff count number
  INIT_COUNT = [0, 0, 0].freeze

  # Initial array for target_files and errors
  INIT_ARRAY = Array.new(2, [])

  attr_reader :add, :del, :mod, :errors
  alias insertions add
  alias deletions del
  alias modifications mod

  # initialize GitDiffLCS::Stat
  #
  # Arguments:
  #   [String] repo: repo git repository address
  #   [String] src: src src commit or branch
  #   [String] dest: dest commit or branch
  def initialize(repo, src, dest)
    @go_next = false
    @dir = Dir.mktmpdir
    @add, @del, @mod = *INIT_COUNT
    @target_files, @errors = *Array.new(2, [])
    @diff = git_clone(repo, src, dest).diff(src, dest)
    calculate
  rescue Git::GitExecuteError
    @errors << "[ERROR] wrong git info(repository or src or dest)"
  ensure
    FileUtils.rm_rf(@dir)
  end

  # Get diff summary
  # changed files, insertions, deletions, modifications and total
  #
  # Return:
  #   [String] diff summary
  #
  # Example:
  #   >> stat = GitDiffLCS::Stat.new("https://github.com/btpink-seo/git-diff-lcs.git", "test/src", "test/dest")
  #   >> stat.summary
  #   => 5 files changed, 13 insertions(+), 6 deletions(-), 2 modifications(!), total(21)
  def summary
    total = @add + @del + @mod
    changed = @target_files.size
    "#{changed} files changed, #{@add} insertions(+), #{@del} deletions(-), #{@mod} modifications(!), total(#{total})"
  end

  private

  # git clone and copy to destination folder for compare
  def git_clone(repo, src, dest)
    git = Git.clone(repo, SRC_FOLDER, path: @dir)
    git.checkout(dest)
    FileUtils.copy_entry("#{@dir}/#{SRC_FOLDER}", "#{@dir}/#{DEST_FOLDER}")
    git.checkout(src)
    git
  end

  # open_src_file
  # if dosen't exist file, add insertions all dest line length
  def open_src_file(src_filename, dest_filename)
    File.open(src_filename)
  rescue Errno::ENOENT
    # new file in dest
    @add += open_dest_file(nil, dest_filename).readlines.size
    @go_next = true
  end

  # open_dest_file
  # if dosen't exist file, add deletions all src line length
  def open_dest_file(src, dest_filename)
    File.open(dest_filename)
  rescue Errno::ENOENT
    # deleted file in dest
    @del += src.readlines.size
    @go_next = true
  end

  # add each count variable
  def add_result(diff)
    @add += 1 if diff.adding?
    @del += 1 if diff.deleting?
    @mod += 1 if diff.changed?
  end

  # count diff
  def calculate
    @target_files = @diff.name_status.keys
    @target_files.each do |file|
      src_filename = "#{@dir}/#{SRC_FOLDER}/#{file}"
      dest_filename = "#{@dir}/#{DEST_FOLDER}/#{file}"

      src = open_src_file(src_filename, dest_filename)
      dest = open_dest_file(src, dest_filename)

      next if @go_next && !(@go_next = !@go_next)
      next if FileUtils.cmp(src_filename, dest_filename)

      Diff::LCS.sdiff(src.readlines, dest.readlines).each { |d| add_result(d) }
    end
  end
end

dir = Dir.mktmpdir
# DiffWithModification.new
# param1(String) : directory for clone
# param2(String) : git address
# param3(String) : src commit
# param4(String) : dest commit
diff = DiffWithModification.new(dir, ARGV[0], ARGV[1], ARGV[2])
puts diff.summary

FileUtils.rm_rf(dir)
