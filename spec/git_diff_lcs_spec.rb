# frozen_string_literal: true

# rubocop:disable Layout/LineLength, Metrics/BlockLength
RSpec.describe GitDiffLcs do
  let(:repo) { "https://github.com/btpink-seo/git-diff-lcs.git" }
  let(:src_branch) { "test/src" }
  let(:dest_branch) { "test/dest" }
  let(:src_commit) { "61b3d41274ada7e24d6a49d46f8b0665b283f0b2" }
  let(:dest_commit) { "cace7fcc5366a3f5e19976eb2cafa92c7a5793a1" }

  it "has a version number" do
    expect(GitDiffLcs::VERSION).not_to be nil
  end

  it "diff result" do
    result = GitDiffLcs.diff(repo, src_branch, dest_branch)
    expect(result).to eq("5 files changed, 13 insertions(+), 6 deletions(-), 2 modifications(!), total(21)")
  end

  describe "GitDiffLcs::Stat" do
    context "branch" do
      let!(:stat_branch) { GitDiffLcs::Stat.new(repo, src_branch, dest_branch) }

      it "summary" do
        expect(stat_branch.summary).to eq("5 files changed, 13 insertions(+), 6 deletions(-), 2 modifications(!), total(21)")
      end

      it "insertions" do
        expect(stat_branch.insertions).to eq(13)
      end

      it "deletions" do
        expect(stat_branch.deletions).to eq(6)
      end

      it "modifications" do
        expect(stat_branch.modifications).to eq(2)
      end
    end

    context "commit" do
      let!(:stat_commit) { GitDiffLcs::Stat.new(repo, src_commit, dest_commit) }

      it "summary" do
        expect(stat_commit.summary).to eq("5 files changed, 13 insertions(+), 6 deletions(-), 2 modifications(!), total(21)")
      end

      it "insertions" do
        expect(stat_commit.insertions).to eq(13)
      end

      it "deletions" do
        expect(stat_commit.deletions).to eq(6)
      end

      it "modifications" do
        expect(stat_commit.modifications).to eq(2)
      end
    end

    context "mix(branch, commit)" do
      let!(:stat_mix1) { GitDiffLcs::Stat.new(repo, src_branch, dest_commit) }
      let!(:stat_mix2) { GitDiffLcs::Stat.new(repo, src_commit, dest_branch) }

      it "summary" do
        expect(stat_mix1.summary).to eq("5 files changed, 13 insertions(+), 6 deletions(-), 2 modifications(!), total(21)")
        expect(stat_mix2.summary).to eq("5 files changed, 13 insertions(+), 6 deletions(-), 2 modifications(!), total(21)")
      end

      it "insertions" do
        expect(stat_mix1.insertions).to eq(13)
        expect(stat_mix2.insertions).to eq(13)
      end

      it "deletions" do
        expect(stat_mix1.deletions).to eq(6)
        expect(stat_mix2.deletions).to eq(6)
      end

      it "modifications" do
        expect(stat_mix1.modifications).to eq(2)
        expect(stat_mix2.modifications).to eq(2)
      end
    end
  end
end
# rubocop:enable Layout/LineLength, Metrics/BlockLength
