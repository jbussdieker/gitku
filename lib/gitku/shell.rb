module Gitku
  class Shell
    attr_accessor :username

    def initialize(args)
      @username = args[1]
      @command = ENV['SSH_ORIGINAL_COMMAND']
      @config = Gitku.config
    end

    def run
      if @command
        ENV["GITKU_USER"] = @username
        FileUtils.chdir(@config[:repo_dir])
        Kernel.exec 'git', 'shell', '-c', @command
      else
        Kernel.exec 'git-shell'
      end
    end

    def self.run(args)
      new(args).run
    end
  end
end
