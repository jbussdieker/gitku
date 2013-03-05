require "bundler/gem_tasks"
require "rspec/core/rake_task"

RSpec::Core::RakeTask.new do |t|
  t.rspec_opts = %w[--color]
end

task :test do
  require 'gitku'
  Dir.mktmpdir do |tmpdir|
    Gitku.configure(:repo_dir => tmpdir)
    Gitku.repositories.create("test")
  end
end
