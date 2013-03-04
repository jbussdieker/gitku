require 'fileutils'

module Gitku
  class Project
    attr_accessor :name

    def initialize(name)
      @name = name
      @config = Gitku.config
    end

    def root_path
      File.expand_path(File.join(@config[:repo_dir], @name))
    end

    def vcs_url
      prefix = @config[:prefix] || @config[:repo_dir] + "/" || "git://"
      prefix + name
    end

    def delete
      FileUtils.rm_rf(root_path)
    end

    def exists?
      File.exists? root_path
    end

    def update_hooks
      hooks_filter = File.join(@config[:hooks_dir], "*")
      project_hooks = File.join(root_path, "hooks")
      IO.popen("ln -f #{hooks_filter} #{project_hooks} 2>&1").readlines
    end

    def create_repo
      FileUtils.mkdir(root_path)
      IO.popen("cd #{root_path}; git init --bare").readlines
    end

    def create
      create_repo
      update_hooks
      nil
    end

    def self.all
      config = Gitku.config
      filter = File.join(config[:repo_dir], "*")
      Dir[filter].collect {|v| new(v.split("/").last)}
    end

    def self.find(name)
      item = new(name)
      item if item.exists?
    end

    def self.create(name)
      item = new(name)
      item.create
      item
    end
  end
end
