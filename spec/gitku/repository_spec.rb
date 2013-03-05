require 'gitku'
require 'tmpdir'

describe Gitku::Repository do
  def path(name = @repository_name)
    File.join(@tmpdir, name)
  end

  before do
    @tmpdir = Dir.mktmpdir
    Gitku.configure(:repo_dir => @tmpdir)
    @repository_name = "repository1"
    @repository = Gitku::Repository.create(@repository_name)
  end

  after do
    FileUtils.remove_entry_secure @tmpdir
  end

  it "should create" do
    Gitku::Repository.create("repository2")
    File.exists?(path("repository2")).should be_true
  end

  it "should rename properly" do
    @repository.rename("repository1a")
    File.exists?(path).should be_false
    File.exists?(path("repository1a")).should be_true
  end

  it "should create the root" do
    File.exists?(path).should eql(true)
  end

  it "should create git hooks" do
    File.exists?(File.join(path, "hooks")).should eql(true)
  end

  it "should be in collection" do
    names = Gitku::Repository.collect {|r|r.name}
    names.include?(@repository.name).should be_true
  end

  it "should be findable" do
    Gitku::Repository.find(@repository_name).name.should eql(@repository_name)
  end

  it "should delete properly" do
    @repository.delete
    File.exists?(path).should be_false
  end

  it { @repository.exists?.should be_true }
  it { @repository.should respond_to(:name) }
  it { @repository.should respond_to(:path) }
  it { @repository.should respond_to(:url) }
  it { @repository.should respond_to(:delete) }
  it { @repository.should respond_to(:exists?) }
  it { @repository.should respond_to(:create) }
end
