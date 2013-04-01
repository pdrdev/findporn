require 'rspec'
Dir[File.dirname(__FILE__) + '/../lib/*'].each {|file| require file.gsub('file:', '') }

describe OptProcessor do

  it "should fail on unknown argument" do
    processor = OptProcessor.new(['--do-unknown-stuff'])
    processor.error?.should == true
  end

  it "should use default do-login" do
    processor = OptProcessor.new([])
    processor.error?.should == false
    processor.do_login?.should == OptProcessor::DEFAULT_TO_LOGIN
  end

  it "should log in if there's the arg'" do
    processor = OptProcessor.new(['--do-login'])
    processor.error?.should == false
    processor.do_login?.should == true
  end

  it "should use default verbose" do
    processor = OptProcessor.new([])
    processor.error?.should == false
    processor.verbose?.should == OptProcessor::DEFAULT_VERBOSE
  end

  it "should be verbose if specified" do
    processor = OptProcessor.new(['-v'])
    processor.error?.should == false
    processor.verbose?.should == true

    processor = OptProcessor.new(['--verbose'])
    processor.error?.should == false
    processor.verbose?.should == true
  end

  it "should use default max-hrefs" do
    processor = OptProcessor.new([])
    processor.error?.should == false
    processor.max_hrefs.should == OptProcessor::DEFAULT_MAX_HREFS
  end

  it "should use specified max-hrefs" do
    processor = OptProcessor.new(['--max-hrefs', '123'])
    processor.error?.should == false
    processor.max_hrefs.should == 123
  end
end