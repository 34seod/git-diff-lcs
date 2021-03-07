# frozen_string_literal: true

require "thor"

module GitDiffLCS
  # Command Line Interface
  class CLI < Thor
    def self.exit_on_failure?
      true
    end

    desc "shortstat GIT_REPOSITORY SRC(BRANCH OR COMMIT) DEST(BRANCH OR COMMIT)", "get diff with LCS"
    def shortstat(repo, src, dest)
      puts GitDiffLCS.shortstat(repo, src, dest)
    end
  end
end
