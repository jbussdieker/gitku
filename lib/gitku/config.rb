require 'yaml'

module Gitku
  @@config = {}

  def self.load_config
    if File.exists? "/etc/gitku/settings.yml"
      configure YAML.load(File.open("/etc/gitku/settings.yml"))
    elsif File.exists? "config/settings.yml"
      configure YAML.load(File.open("config/settings.yml"))
    else
      raise "No config file detected."
    end
  end

  def self.config
    @@config.dup
  end

  def self.configure(opts = {})
    @@config.merge! opts.dup
  end

  load_config
end
