module Gitku
  @@config = {}

  def self.config
    if @@config.length == 0
      if File.exists? "/etc/gitku/settings.yml"
        configure YAML.load(File.open("/etc/gitku/settings.yml"))
      elsif File.exists? "config/settings.yml"
        configure YAML.load(File.open("config/settings.yml"))
      else
        raise "No config file detected."
      end
    end
    @@config.dup
  end

  def self.configure(opts = {})
    @@config.merge! opts.dup
  end
end
