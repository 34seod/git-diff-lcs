# frozen_string_literal: true

require "securerandom"

module GitDiffLCS
  # gem version
  VERSION = "0.1.0"

  # Source folder
  SRC_FOLDER = "src_#{SecureRandom.uuid}"

  # Destination folder
  DEST_FOLDER = "dest_#{SecureRandom.uuid}"

  # Initial diff count number
  INIT_COUNT = [0, 0, 0].freeze
end
