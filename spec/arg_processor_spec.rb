require "rspec"

require "arg_processor"

describe ArgProcessor do

  it "should fail on too many args" do
    processor = ArgProcessor.new(['--do-login', '--do-login'])
    processor.error?.should == true
  end

  it "should fail on unknown argument" do
    processor = ArgProcessor.new(['--do-unknown-stuff'])
    processor.error?.should == true
  end

  it "should not log in by default" do
    processor = ArgProcessor.new([])
    processor.error?.should == false
    processor.do_login == false
  end

  it "should not log in if there's the arg'" do
    processor = ArgProcessor.new(['--do-login'])
    processor.error?.should == false
    processor.do_login == true
  end
end