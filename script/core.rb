# frozen_string_literal: true

# https://qiita.com/s-show/items/c14958abdf35f7c45a88
# https://github.com/ruby-git/ruby-git
# https://github.com/halostatue/diff-lcs
# $ gem install diff-lcs
# $ gem install git
# $ ruby core.rb https://github.com/btpink-seo/git-diff-lcs.git main gem

require "diff/lcs"
require "fileutils"
require "git"

# CORE
class DiffWithModification
  SRC_FOLDER = "diff_src"
  DEST_FOLDER = "diff_dest"

  def initialize(repo, src, dest)
    @go_next = false
    @dir = Dir.mktmpdir
    @add = 0
    @del = 0
    @mod = 0
    @target_files = []

    @diff = git_clone(repo, src, dest).diff(src, dest)
    @target_files = @diff.name_status.keys
    calculate
  rescue Git::GitExecuteError
    puts "[ERROR] wrong git info(repo or src or dest)"
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

  def close
    FileUtils.rm_rf(@dir)
  end

  def git_clone(repo, src, dest)
    git_src = Git.clone(repo, SRC_FOLDER, path: @dir)
    git_dest = Git.clone(repo, DEST_FOLDER, path: @dir)
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
    close
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
puts diff.summary

FileUtils.rm_rf(dir)
