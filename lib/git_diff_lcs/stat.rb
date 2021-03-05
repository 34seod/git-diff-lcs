require 'diff/lcs'
require 'fileutils'
require 'git'

module GitDiffLcs
  class Stat
    SRC_FOLDER = 'diff_src'.freeze
    DEST_FOLDER = 'diff_dest'.freeze

    def initialize(dir, git, src, dest)
      git_src = Git.clone(git, SRC_FOLDER, path: dir)
      git_dest = Git.clone(git, DEST_FOLDER, path: dir)
      git_src.checkout(dest)
      git_src.checkout(src)
      git_dest.checkout(dest)

      @dir = dir
      @diff = git_src.diff(src, dest)
      @target_files = @diff.name_status.keys
      @add = 0
      @del = 0
      @mod = 0
      calculate
    end

    def summary
      "#{@target_files.size} files changed, #{@add} insertions(+), #{@del} deletions(-), #{@mod} modifications(!), total(#{@add + @del + @mod})"
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

    def calculate
      @target_files.each do |file|
        src_filename = "#{@dir}/#{SRC_FOLDER}/#{file}"
        dest_filename = "#{@dir}/#{DEST_FOLDER}/#{file}"

        begin
          src = File.open(src_filename)
        rescue Errno::ENOENT
          # p "new file in dest #{file}"
          (@add = @add + File.open(dest_filename).readlines.size) rescue nil
          next
        end

        begin
          dest = File.open(dest_filename)
        rescue Errno::ENOENT
          # p "deleted file in dest #{file}"
          @del = @del + src.readlines.size
          next
        end

        unless FileUtils.cmp(src_filename, dest_filename)
          diffs = Diff::LCS.sdiff(src.readlines, dest.readlines)
          diffs.each do |d|
            @add += 1 if d.adding?
            @del += 1 if d.deleting?
            @mod += 1 if d.changed?
            # p dest_filename, d if d.adding? || d.deleting? || d.changed?
          end
        end
      end
    end
  end
end
