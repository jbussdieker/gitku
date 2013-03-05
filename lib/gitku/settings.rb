require 'yaml'

module Gitku
  class Settings < Hash
    # Allow accessing hash items as methods
    def method_missing(item, *args)
      self[item] if self.has_key? item
    end

    # Read configuration options from file
    def self.new_from_file(file)
      opts = YAML.load(File.open(file))
      new.merge! opts
    end
  end

  # Get global configuration settings
  def self.config
    @@config.dup
  end

  # Set global configuration settings
  def self.configure(opts = {})
    @@config.merge! opts.dup
  end

  private

  def self.load_defaults
    repo_dir = File.expand_path(".gitku/repos", "~")
    hooks_dir = File.expand_path(".gitku/hooks", "~")
    Settings.new.merge(:repo_dir => repo_dir, :hooks_dir => hooks_dir)
  end

  def self.load_config
    ["/etc/gitku/settings.yml", "config/settings.yml"].each do |config_file|
      if File.exists? config_file
        return Settings.new_from_file(config_file)
      end
    end
    load_defaults
  end

  @@config = load_config
end
