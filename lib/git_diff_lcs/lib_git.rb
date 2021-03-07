# frozen_string_literal: true

require "git"

module GitDiffLCS
  # Git
  class LibGit
    attr_reader :git

    # initialize GitDiffLCS::LibGit
    #
    # Arguments:
    #   [String] git_target: git repository address or working directory
    #   [String] dir: temporary folder
    #   [String] src: commit or branch
    #   [String] dest: commit or branch
    def initialize(git_target, dir, src, dest)
      @dir = dir
      @src = src
      @dest = dest
      get_git(git_target)
    end

    def diff
      @diff ||= @git.diff(@src, @dest)
    end

    private

    # Git.open or Git.clone
    def get_git(git_target)
      git_clone(git_target)
    rescue Git::GitExecuteError
      git_open(git_target)
    end

    # If there is no folder, create a new one.
    def copy_with_path(src_file, dest_file)
      FileUtils.mkpath(File.dirname(dest_file))
      FileUtils.cp(src_file, dest_file)
    rescue Errno::ENOENT
      nil
    end

    def copy_to_tmp(commit, src_dir, dest_dir)
      @git.checkout(commit)
      diff.name_status.each do |filename, _|
        copy_with_path("#{@dir}/#{src_dir}/#{filename}", "#{@dir}/#{dest_dir}/#{filename}")
      end
    end

    # git open and copy to destination folder for compare
    def git_open(working_dir)
      @git = Git.open(working_dir)
      prev_branch = @git.branch.name
      @git.checkout(@src)
      copy_to_tmp(@dest, working_dir, GitDiffLCS::DEST_FOLDER)
      copy_to_tmp(@src, working_dir, GitDiffLCS::SRC_FOLDER)
      @git.checkout(prev_branch)
    end

    # git clone and copy to destination folder for compare
    def git_clone(repo)
      @git = Git.clone(repo, GitDiffLCS::SRC_FOLDER, path: @dir)
      @git.checkout(@src)
      copy_to_tmp(@dest, GitDiffLCS::SRC_FOLDER, GitDiffLCS::DEST_FOLDER)
      @git.checkout(@src)
    end
  end
end
