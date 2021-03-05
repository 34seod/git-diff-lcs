# https://qiita.com/s-show/items/c14958abdf35f7c45a88
# https://github.com/ruby-git/ruby-git
# https://github.com/halostatue/diff-lcs
# $ gem install diff-lcs
# $ gem install git
# $ ruby diff_git_clone.rb http://dev-redmine.being.group/git/clc b32601d26a2e36a38a95b1a5062ed725fb6b9891 e971cdb8066b7e5dee404964d97d7bb4e44d6ead
# $ ruby diff_git_clone.rb http://dev-redmine.being.group/git/clc 8c3547373c7d499e140437dc1c5bb6ecc7b65fab a637f50e5aefc0c52f56c217a73a38a4782e3f21
# $ ruby diff_git_clone.rb http://dev-redmine.being.group/git/clc release/1.7.0 develop

require 'diff/lcs'
require 'fileutils'
require 'git'
require 'pry'

class DiffWithModification
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
    puts "#{@target_files.size} files changed, #{@add} insertions(+), #{@del} deletions(-), #{@mod} modifications(!), total(#{@add + @del + @mod})"
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
        p "new file in dest #{file}"
        (@add = @add + File.open(dest_filename).readlines.size) rescue 'rescue'
        next
      end

      begin
        dest = File.open(dest_filename)
      rescue Errno::ENOENT
        p "deleted file in dest #{file}"
        @del = @del + src.readlines.size
        next
      end

      unless FileUtils.cmp(src_filename, dest_filename)
        diffs = Diff::LCS.sdiff(src.readlines, dest.readlines)
        diffs.each do |d|
          @add += 1 if d.adding?
          @del += 1 if d.deleting?
          @mod += 1 if d.changed?
          p dest_filename, d if d.adding? || d.deleting? || d.changed?
        end
        binding.pry
      end
    end
  end
end

Dir.mktmpdir do |dir|
  # DiffWithModification.new
  # param1(String) : directory for clone
  # param2(String) : git address
  # param3(String) : src commit
  # param4(String) : dest commit
  diff = DiffWithModification.new(dir, ARGV[0], ARGV[1], ARGV[2])
  diff.summary
end
