module Gitku
  class Command
    @@commands = {
      :list => {},
      :config => {},
      :create => {:name => "Repository Name"},
      :delete => {:name => "Repository Name"},
      :rename => {:from => "Source Name", :to => "Destination Name"},
    }

    def initialize(args)
      @command = args[0].to_s.to_sym
      @args = args[1..-1]
    end

    def run
      send(@command, *@args) if respond_to? @command
      respond_to? @command
    end

    def self.run(args)
      new(args).run
    end

    # Print command line usage information
    def print_usage
      puts "gitku COMMAND [ARGS]"
      puts
      puts "commands:"
      @@commands.each do |name, args|
        puts "  " + name.to_s + " " + args.collect {|name, description| name.to_s.capitalize}.join(" ")
      end
      puts
    end

    def update_hooks
      Gitku::Repository.each do |project|
        project.update_hooks
      end
    end

    # Display global application settings
    def config
      Gitku.config.each do |name, value|
        puts "#{name} = #{value}"
      end
    end

    def clone(name)
      repository = Repository.find(name)
      puts IO.popen("git clone #{repository.url}").readlines
    end

    # Run interactive repository list
    def list
      puts "Repositories"
      Gitku::Repository.each do |repository|
        puts " * #{repository.name}\n   url: #{repository.url} #{repository.origin}"
      end
    end

    # Run interactive repository create
    def create(name, remote = nil)
      begin
        repository = Gitku::Repository.create(name, remote)
        puts "Created #{name}"
        puts "  git remote add #{Gitku.config.remote_name} #{repository.url}"
        puts "  git push -u #{Gitku.config.remote_name} master"
      rescue Exception => e
        puts "Error creating #{name}. #{e.message}"
      end
    end

    # Run interactive repository rename
    def rename(name, newname)
      repository = Repository.find(name)
      if repository
        Repository.rename(name, newname)
        puts "Renamed #{name} to #{newname}"
      else
        puts "Repository not found"
      end
    end

    def update
      Gitku::Repository.each do |repo|
        repo.fetch
      end
    end

    # Run interactive repository delete
    def delete(name)
      repository = Gitku::Repository.find(name)
      if repository
        repository.delete
        puts "Deleted #{name}"
      else
        puts "Repository not found"
      end
    end
  end
end
