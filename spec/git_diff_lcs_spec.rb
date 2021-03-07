# frozen_string_literal: true

# rubocop:disable Layout/LineLength, Metrics/BlockLength
RSpec.describe GitDiffLCS do
  let(:repo) { "https://github.com/btpink-seo/git-diff-lcs.git" }
  let(:working_dir) { "." }
  let(:src_branch) { "test/src" }
  let(:dest_branch) { "test/dest" }
  let(:src_commit) { "61b3d41274ada7e24d6a49d46f8b0665b283f0b2" }
  let(:dest_commit) { "cace7fcc5366a3f5e19976eb2cafa92c7a5793a1" }

  it "has a version number" do
    expect(GitDiffLCS::VERSION).not_to be nil
  end

  it "shortstat repository result" do
    result = GitDiffLCS.shortstat(repo, src_branch, dest_branch)
    expect(result).to eq(" 5 files changed, 13 insertions(+), 6 deletions(-), 2 modifications(!), total(21)")
  end

  it "shortstat working_dir result" do
    result = GitDiffLCS.shortstat(working_dir, src_branch, dest_branch)
    expect(result).to eq(" 5 files changed, 13 insertions(+), 6 deletions(-), 2 modifications(!), total(21)")
  end

  it "must be error when wrong git info" do
    result = GitDiffLCS.shortstat("", "", "")
    expect(result).to eq("[ERROR] wrong arguments")
  end

  describe "GitDiffLCS::Stat" do
    it "must be error when wrong git info" do
      stat_errors = GitDiffLCS::Shortstat.new("", "", "").errors
      expect(stat_errors.empty?).to be_falsey
      expect(stat_errors.first).to eq("[ERROR] wrong arguments")
    end

    context "repository" do
      it "shorstat src_branch, dest_branch" do
        stat_branch = GitDiffLCS::Shortstat.new(repo, src_branch, dest_branch)
        expect(stat_branch.summary).to eq(" 5 files changed, 13 insertions(+), 6 deletions(-), 2 modifications(!), total(21)")
        expect(stat_branch.insertions).to eq(13)
        expect(stat_branch.deletions).to eq(6)
        expect(stat_branch.modifications).to eq(2)
      end

      it "shorstat src_commit, dest_commit" do
        stat_commit = GitDiffLCS::Shortstat.new(repo, src_commit, dest_commit)
        expect(stat_commit.summary).to eq(" 5 files changed, 13 insertions(+), 6 deletions(-), 2 modifications(!), total(21)")
        expect(stat_commit.insertions).to eq(13)
        expect(stat_commit.deletions).to eq(6)
        expect(stat_commit.modifications).to eq(2)
      end

      it "shorstat src_branch, dest_commit" do
        stat_mix = GitDiffLCS::Shortstat.new(repo, src_branch, dest_commit)
        expect(stat_mix.summary).to eq(" 5 files changed, 13 insertions(+), 6 deletions(-), 2 modifications(!), total(21)")
        expect(stat_mix.insertions).to eq(13)
        expect(stat_mix.deletions).to eq(6)
        expect(stat_mix.modifications).to eq(2)
      end

      it "shorstat src_commit, dest_branch" do
        stat_mix = GitDiffLCS::Shortstat.new(repo, src_commit, dest_branch)
        expect(stat_mix.summary).to eq(" 5 files changed, 13 insertions(+), 6 deletions(-), 2 modifications(!), total(21)")
        expect(stat_mix.insertions).to eq(13)
        expect(stat_mix.deletions).to eq(6)
        expect(stat_mix.modifications).to eq(2)
      end
    end

    context "working_dir" do
      it "shorstat src_branch, dest_branch" do
        stat_branch = GitDiffLCS::Shortstat.new(working_dir, src_branch, dest_branch)
        expect(stat_branch.summary).to eq(" 5 files changed, 13 insertions(+), 6 deletions(-), 2 modifications(!), total(21)")
        expect(stat_branch.insertions).to eq(13)
        expect(stat_branch.deletions).to eq(6)
        expect(stat_branch.modifications).to eq(2)
      end

      it "shorstat src_commit, dest_commit" do
        stat_commit = GitDiffLCS::Shortstat.new(working_dir, src_commit, dest_commit)
        expect(stat_commit.summary).to eq(" 5 files changed, 13 insertions(+), 6 deletions(-), 2 modifications(!), total(21)")
        expect(stat_commit.insertions).to eq(13)
        expect(stat_commit.deletions).to eq(6)
        expect(stat_commit.modifications).to eq(2)
      end

      it "shorstat src_branch, dest_commit" do
        stat_mix = GitDiffLCS::Shortstat.new(working_dir, src_branch, dest_commit)
        expect(stat_mix.summary).to eq(" 5 files changed, 13 insertions(+), 6 deletions(-), 2 modifications(!), total(21)")
        expect(stat_mix.insertions).to eq(13)
        expect(stat_mix.deletions).to eq(6)
        expect(stat_mix.modifications).to eq(2)
      end

      it "shorstat src_commit, dest_branch" do
        stat_mix = GitDiffLCS::Shortstat.new(working_dir, src_commit, dest_branch)
        expect(stat_mix.summary).to eq(" 5 files changed, 13 insertions(+), 6 deletions(-), 2 modifications(!), total(21)")
        expect(stat_mix.insertions).to eq(13)
        expect(stat_mix.deletions).to eq(6)
        expect(stat_mix.modifications).to eq(2)
      end
    end
  end
end
# rubocop:enable Layout/LineLength, Metrics/BlockLength
