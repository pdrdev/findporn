# encoding: utf-8

require 'rspec'
require 'nokogiri'

Dir[File.dirname(__FILE__) + '/../lib/findporn/*'].each {|file| require file.gsub('file:', '') }

describe Href do

  it "should parse hrefs" do
    title_element = Nokogiri::XML('<a class="med tLink bold" href="./viewtopic.php?t=1234">Some title</a>').root
    size_element = Nokogiri::XML('<a class="small tr-dl dl-stub" href="dl.php?t=1729624">356&nbsp;MB</a>').root
    upload_element = Nokogiri::XML('<td class="row4 small nowrap" style="padding: 1px 3px 2px;" title="Добавлен"><u>1380690608</u><p>08:10</p><p>2-Окт-13</p>	</td>').root

    href = Href.create(title_element, size_element, upload_element, true, nil)

    href.title.should == 'Some title'
    href.url.should == './viewtopic.php?t=1234'

    href.size_raw.should == '356MB'

    href.uploaded_timestamp.should == 1380701400
  end
end
