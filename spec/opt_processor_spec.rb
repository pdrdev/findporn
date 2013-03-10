require "rspec"

require "opt_processor"

describe OptProcessor do

  it "should fail on unknown argument" do
    processor = OptProcessor.new(['--do-unknown-stuff'])
    processor.error?.should == true
  end

  it "should not log in by default" do
    processor = OptProcessor.new([])
    processor.error?.should == false
    processor.do_login == false
  end

  it "should log in if there's the arg'" do
    processor = OptProcessor.new(['--do-login'])
    processor.error?.should == false
    processor.do_login == true
  end

  it "should not be verbose by default" do
    processor = OptProcessor.new([])
    processor.error?.should == false
    processor.verbose == false
  end

  it "should be verbose if specified" do
    processor = OptProcessor.new(['-v'])
    processor.error?.should == false
    processor.verbose == true

    processor = OptProcessor.new(['--verbose'])
    processor.error?.should == false
    processor.verbose == true
  end
end