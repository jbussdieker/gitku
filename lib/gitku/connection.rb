module Gitku
  class Connection
    attr_accessor :username
    attr_accessor :command

    def initialize(args)
      username = args[0]
      @ssh_command = ENV['SSH_ORIGINAL_COMMAND'] || ""
      ENV["GITKU_USER"] = username
    end

    def run
      command = Command.new(@ssh_command.split)
      unless command.run
        FileUtils.chdir(config.repo_dir)
        Kernel.exec 'git', 'shell', '-c', @ssh_command
      end
    end

private

    def config
      @config ||= Gitku.config
    end
  end
end
