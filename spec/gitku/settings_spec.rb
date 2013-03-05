require 'gitku'

describe Gitku do
  it { should respond_to(:config) }
end

describe Gitku::Settings do
  before do
    file = File.expand_path("../test.yml", __FILE__)
    @config = Gitku::Settings.new_from_file(file)
  end

  it "merge! should add item" do
    @config.merge!(:setting3 => "value3")
    @config[:setting3].should eql("value3")
  end

  it "merge! should add method" do
    @config.merge!(:setting4 => "value4")
    @config.setting4.should eql("value4")
  end

  it "merge! should override existing settings" do
    @config.merge!(:setting1 => "value1a")
    @config.setting1.should eql("value1a")
  end

  it "should allow changes to hash" do
    @config[:setting1] = "value1b"
    @config.setting1.should eql("value1b")
  end

  it { @config.should respond_to(:[]) }
  it { @config.setting1.should eql("value1") }
  it { @config[:setting1].should eql("value1") }
end
