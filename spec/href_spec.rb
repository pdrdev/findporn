require 'rspec'
require 'nokogiri'

Dir[File.dirname(__FILE__) + '/../lib/findporn/*'].each {|file| require file.gsub('file:', '') }

describe Href do

  it "should parse hrefs" do
    href = Href.create Nokogiri::XML('<a class="med tLink bold" href="./viewtopic.php?t=1234">Some title</a>').root
    href.title.should == 'Some title'
    href.url.should == './viewtopic.php?t=1234'
  end
end
