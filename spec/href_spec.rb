require 'rspec'
Dir[File.dirname(__FILE__) + '/../src/*'].each {|file| require file.gsub('file:', '') }

describe Href do

  it "should parse hrefs" do
    href = Href.new(Nokogiri::XML('<a class="med tLink bold" href="./viewtopic.php?t=1234">Some title</a>').root)
    href.title.should == 'Some title'
    href.url.should == './viewtopic.php?t=1234'
    href.id.should == 1234
  end
end