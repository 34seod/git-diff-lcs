# frozen_string_literal: true

require "diff/lcs"
require "fileutils"
require "git"

# git diff lcs
module GitDiffLcs
  # stat
  class Stat
    SRC_FOLDER = "diff_src"
    DEST_FOLDER = "diff_dest"

    def initialize(git, src, dest)
      @go_next = false
      @dir = Dir.mktmpdir
      @add = 0
      @del = 0
      @mod = 0

      @diff = git_clone(git, dest, src).diff(src, dest)
      @target_files = @diff.name_status.keys
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

    def close
      FileUtils.rm_rf(@dir)
    end

    def git_clone(git, dest, src)
      git_src = Git.clone(git, SRC_FOLDER, path: @dir)
      git_dest = Git.clone(git, DEST_FOLDER, path: @dir)
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
end
