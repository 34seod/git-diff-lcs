# frozen_string_literal: true

require "securerandom"
require "diff/lcs"
require "git"

# git diff lcs
module GitDiffLcs
  # stat
  class Stat
    SRC_FOLDER = "src_#{SecureRandom.uuid}"
    DEST_FOLDER = "dest_#{SecureRandom.uuid}"
    INIT_COUNT = [0, 0, 0].freeze

    # repo(String) : git repository address
    # src(String) : src commit or branch
    # dest(String) : dest commit or branch
    def initialize(repo, src, dest)
      @go_next = false
      @dir = Dir.mktmpdir
      @add, @del, @mod = *INIT_COUNT
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
      git = Git.clone(repo, SRC_FOLDER, path: @dir)
      git.checkout(dest)
      FileUtils.copy_entry("#{@dir}/#{SRC_FOLDER}", "#{@dir}/#{DEST_FOLDER}")
      git.checkout(src)
      git
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

        next if @go_next && !(@go_next = !@go_next)
        next if FileUtils.cmp(src_filename, dest_filename)

        diffs = Diff::LCS.sdiff(src.readlines, dest.readlines)
        diffs.each { |d| add_result(d) }
      end
      close
    end
    # rubocop:enable Metrics/MethodLength
  end
end
