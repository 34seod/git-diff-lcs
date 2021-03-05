# frozen_string_literal: true

# https://qiita.com/s-show/items/c14958abdf35f7c45a88
# https://github.com/ruby-git/ruby-git
# https://github.com/halostatue/diff-lcs
# $ gem install diff-lcs
# $ gem install git

require "diff/lcs"
require "fileutils"
require "git"

# CORE
class DiffWithModification
  SRC_FOLDER = "diff_src"
  DEST_FOLDER = "diff_dest"

  def initialize(dir, git, src, dest)
    git_src = git_clone(git, dir, dest, src)

    @dir = dir
    @go_next = false
    @diff = git_src.diff(src, dest)
    @target_files = @diff.name_status.keys
    @add = 0
    @del = 0
    @mod = 0
    calculate
  end

  def summary
    total = @add + @del + @mod
    changed = @target_files.size
    "#{changed} files changed, #{@add} insertions(+), #{@del} deletions(-), #{@mod} modifications(!), total(#{total})"
  end

  def insertions
    @add
  end

  def deletions
    @del
  end

  def modifications
    @mod
  end

  private

  def git_clone(git, dir, dest, src)
    git_src = Git.clone(git, SRC_FOLDER, path: dir)
    git_dest = Git.clone(git, DEST_FOLDER, path: dir)
    git_src.checkout(dest)
    git_src.checkout(src)
    git_dest.checkout(dest)
    git_src
  end

  def open_src_file(src_filename, dest_filename)
    File.open(src_filename)
  rescue Errno::ENOENT
    # p "new file in dest #{file}"
    @add += open_dest_file(dest_filename).readlines.size
    @go_next = true
  end

  def open_dest_file(dest_filename)
    File.open(dest_filename)
  rescue Errno::ENOENT
    # p "deleted file in dest #{file}"
    @del += src.readlines.size
    @go_next = true
  end

  def add_result(diff)
    # p diff if diff.adding? || diff.deleting? || diff.changed?
    @add += 1 if diff.adding?
    @del += 1 if diff.deleting?
    @mod += 1 if diff.changed?
  end

  # rubocop:disable Metrics/MethodLength
  def calculate
    @target_files.each do |file|
      src_filename = "#{@dir}/#{SRC_FOLDER}/#{file}"
      dest_filename = "#{@dir}/#{DEST_FOLDER}/#{file}"

      src = open_src_file(src_filename, dest_filename)
      dest = open_dest_file(dest_filename)

      if @go_next
        @go_next = false
        next
      end

      next if FileUtils.cmp(src_filename, dest_filename)

      diffs = Diff::LCS.sdiff(src.readlines, dest.readlines)
      diffs.each { |d| add_result(d) }
    end
  end
  # rubocop:enable Metrics/MethodLength
end

dir = Dir.mktmpdir
# DiffWithModification.new
# param1(String) : directory for clone
# param2(String) : git address
# param3(String) : src commit
# param4(String) : dest commit
diff = DiffWithModification.new(dir, ARGV[0], ARGV[1], ARGV[2])
diff.summary

FileUtils.rm_rf(dir)
