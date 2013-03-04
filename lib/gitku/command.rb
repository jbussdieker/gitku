module Gitku
  class Command
    def self.run(args)
      command = args[0]
      if command == "list"
        list
      elsif command == "create"
        create(args[1])
      elsif command == "delete"
        delete(args[1])
      elsif command == "rename"
        rename(args[1], args[2])
      else
        puts "Invalid command: #{args[0]}"
      end
    end

    def self.list
      puts "Projects"
      Project.all.each do |project|
        puts "  #{project.name} #{project.vcs_url}"
      end
    end

    def self.create(name)
      begin
        project = Project.create(name)
        puts "Created #{name} 
  git remote add origin #{project.vcs_url}
  git push -u origin master"
      rescue Exception => e
        puts "Error creating #{name}. #{e.message}"
      end
    end

    def self.rename(name, newname)
      project = Project.find(name)
      if project
        project.rename(newname)
        puts "Renamed #{name} to #{newname}"
      else
        puts "Project not found"
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
