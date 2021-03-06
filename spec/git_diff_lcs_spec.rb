# frozen_string_literal: true

RSpec.describe GitDiffLcs do
  it "has a version number" do
    expect(GitDiffLcs::VERSION).not_to be nil
  end

  it "diff result" do
    result = GitDiffLcs.diff("https://github.com/btpink-seo/git-diff-lcs.git", "test/src", "test/dest")
    expect(result).to eq("5 files changed, 13 insertions(+), 6 deletions(-), 2 modifications(!), total(21)")
  end

  describe "GitDiffLcs::Stat" do
    let!(:stat) { GitDiffLcs::Stat.new("https://github.com/btpink-seo/git-diff-lcs.git", "test/src", "test/dest") }

    it "summary" do
      expect(stat.summary).to eq("5 files changed, 13 insertions(+), 6 deletions(-), 2 modifications(!), total(21)")
    end

    it "insertions" do
      expect(stat.insertions).to eq(13)
    end

    it "deletions" do
      expect(stat.deletions).to eq(6)
    end

    it "modifications" do
      expect(stat.modifications).to eq(2)
    end
  end
end
