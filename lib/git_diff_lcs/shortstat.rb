# frozen_string_literal: true

require "diff/lcs"
require "git"

module GitDiffLCS
  # Shortstat
  class Shortstat
    attr_reader :add, :del, :mod, :errors
    alias insertions add
    alias deletions del
    alias modifications mod

    # initialize GitDiffLCS::Shortstat
    #
    # Arguments:
    #   [String] git_target: git repository address or working directory
    #   [String] src: commit or branch
    #   [String] dest: commit or branch
    def initialize(git_target, src, dest)
      @dir = Dir.mktmpdir
      @add, @del, @mod = *GitDiffLCS::INIT_COUNT
      @errors = []
      @git = GitDiffLCS::LibGit.new(git_target, @dir, src, dest)
      calculate
    rescue Git::GitExecuteError, ArgumentError
      @errors << "[ERROR] wrong arguments"
    ensure
      FileUtils.rm_rf(@dir)
    end

    # Get diff summary
    # changed files, insertions, deletions, modifications and total
    #
    # Return:
    #   [String] diff summary
    def summary
      " #{@git.diff.name_status.keys.size} files changed, "\
      "#{@add} insertions(+), #{@del} deletions(-), #{@mod} modifications(!), "\
      "total(#{@add + @del + @mod})"
    end

    private

    # add each count variable
    def add_result(diff)
      @add += 1 if diff.adding?
      @del += 1 if diff.deleting?
      @mod += 1 if diff.changed?
    end

    # count diff
    # rubocop:disable Metrics/AbcSize, Metrics/MethodLength
    def calculate
      @git.diff.name_status.each do |filename, status|
        src_filename = "#{@dir}/#{GitDiffLCS::SRC_FOLDER}/#{filename}"
        dest_filename = "#{@dir}/#{GitDiffLCS::DEST_FOLDER}/#{filename}"

        case status
        when "A"
          @add += File.open(dest_filename).readlines.size
          next
        when "D"
          @del += File.open(src_filename).readlines.size
          next
        else
          src = File.open(src_filename)
          dest = File.open(dest_filename)
          Diff::LCS.sdiff(src.readlines, dest.readlines).each { |d| add_result(d) }
        end
      end
    end
    # rubocop:enable Metrics/AbcSize, Metrics/MethodLength
  end
end
