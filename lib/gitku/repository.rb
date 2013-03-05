require 'gitku/repositories'
require 'fileutils'

module Gitku
  class Repository
    extend Repositories

    # Repository name
    attr_accessor :name

    # Create a new reference to a repository
    def initialize(name)
      @name = name
    end

    # Root of the Repository
    def path(name = name)
      File.expand_path(name + ".git", config.repo_dir)
    end

    # Check if the Repository exists
    def exists?
      File.exists? path
    end

    def git_config
      File.read(File.join(path, "config"))
    end

    # Delete the Repository and all files
    def delete
      FileUtils.rm_rf(path)
    end

    # Rename an existing Repository
    def rename(newname)
      FileUtils.mv(path, path(newname))
    end

    # The url of the Repository
    def url
      prefix = (config.prefix || config.repo_dir + "/") + name
    end

    # Create the bare git repository and update the hooks
    def create
      FileUtils.mkdir_p(path)
      git_init_bare
      update_hooks
    end

    # Fetch remote repo. Either clone or git fetch
    def fetch(remote = nil)
      if remote
        git_clone_bare(remote)
      else
        git_fetch unless origin.empty?
      end
      update_hooks
    end

    def origin
      `cd #{path} && git remote show`.strip
    end

private

    def config
      @config ||= Gitku.config
    end

    def update_hooks
      hooks_filter = File.join(config.hooks_dir, "*")
      project_hooks = File.join(path, "hooks")
      IO.popen("ln -f #{hooks_filter} #{project_hooks} 2>&1").readlines
    end

    def git_clone_bare(remote)
      IO.popen("cd #{config.repo_dir}; git clone #{remote} --bare").readlines
    end

    def git_fetch
      IO.popen("cd #{path}; git fetch").readlines
    end

    def git_init_bare
      IO.popen("cd #{path}; git init --bare").readlines
    end
  end
end
