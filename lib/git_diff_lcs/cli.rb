# frozen_string_literal: true

require "thor"

# Git Diff LCS
module GitDiffLcs
  # Command Line Interface
  class CLI < Thor
    def self.exit_on_failure?
      true
    end

    desc "diff GIT_REPOSITORY, SRC(BRANCH OR COMMIT), DEST(BRANCH OR COMMIT)", "get diff with LCS"
    def diff(repo, src, dest)
      puts GitDiffLcs.diff(repo, src, dest)
    end
  end
end
