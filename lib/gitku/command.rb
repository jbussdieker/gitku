module Gitku
  class Command
    def self.run
      command = ARGV[0]
      if command == "list"
        list
      elsif command == "create"
        create(ARGV[1])
      elsif command == "delete"
        delete(ARGV[1])
      else
        puts "Invalid command: #{ARGV[0]}"
      end
    end

    def self.list
      puts "Projects"
      Project.all.each do |project|
        puts "  #{project.name}"
      end
    end

    def self.create(name)
      begin
        project = Project.create(name)
        puts "Created #{name} 
  git remote add origin #{project.root_path}
  git push -u origin master"
      rescue Exception => e
        puts "Error creating #{name}. #{e.message}"
      end
    end

    def self.delete(name)
      project = Project.find(name)
      if project
        project.delete
        puts "Deleted #{name}"
      else
        puts "Project not found"
      end
    end
  end
end
