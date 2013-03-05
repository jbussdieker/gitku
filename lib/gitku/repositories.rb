module Gitku
  module Repositories
    include Enumerable

    # Create a new Repository
    def create(name, remote)
      FileUtils.mkdir_p(Gitku.config.repo_dir)
      item = Repository.new(name)
      if remote
        item.fetch(remote)
      else
        item.create
      end
      item
    end

    # Find an existing Repository
    def find(name)
      each do |item|
        return item if item.name == name
      end
      nil
    end

    # Rename an existing Repository
    def rename(from, to)
      new(from).rename(to)
    end

    # Iterate through the list of repositories
    def each(&block)
      filter = File.join(Gitku.config.repo_dir, "**", "*.git")
      @list = Dir[filter].collect {|v| 
        name = v.gsub(/^#{Gitku.config.repo_dir}\//, "")
        Repository.new(name.split(".").first)
      }
      @list.each {|item| yield(item)}
    end
  end
end
