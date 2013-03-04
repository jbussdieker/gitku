module Gitku
  class Shell
    attr_accessor :user

    def initialize(args)
      @user = args[1]
    end

    def run
      $stderr.puts "BAMFDUDE ERROR"
      puts "BAMFDUDE"
    end

    def self.run(args)
      new(args).run
    end
  end
end
