$LOAD_PATH.unshift File.expand_path('../lib', __FILE__)
require 'git_diff_lcs/version'

Gem::Specification.new do |spec|
  spec.name        = 'git_diff_lcs'
  spec.version     = GitDiffLcs::VERSION
  spec.summary     = '[git diff --stat] with modifications'
  spec.description = 'Generally, git diff --stat does not contain modifications, so we added it to display modifications using the LCS algorithm.'
  spec.authors     = ['SEO SANG HYUN']
  spec.email       = 'btpink.seo@gmail.com'
  spec.files       = ['lib/git_diff_lcs.rb', 'lib/git_diff_lcs/stat.rb', 'lib/git_diff_lcs/version.rb']
  spec.homepage    = 'https://github.com/btpink-seo/git-diff-lcs'
  spec.license     = 'MIT'
  spec.add_dependency "diff-lcs", "1.4.4"
  spec.add_dependency "git", "1.8.1"
end
