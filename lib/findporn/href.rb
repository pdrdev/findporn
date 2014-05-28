# Parsing hyper references like
# <a class="med tLink bold" href="./viewtopic.php?t=1234">Some title</a>
class Href
  attr_reader :title
  attr_reader :url
  attr_reader :query

  attr_reader :size
  attr_reader :size_raw

  attr_reader :upload_timestamp
  attr_reader :upload_raw

  attr_accessor :id

  def self.create(href_title_str, href_size_str, href_upload_str, query = nil)
    doc = href_title_str
    title = doc.text
    url = doc.get_attribute('href')

    size_raw = href_size_str.text

    upload_str = href_upload_str.to_html
    href_upload_str = Nokogiri::XML(upload_str)

    time_str = href_upload_str.xpath("//p[contains(text(),':')]")[0].text
    date_str = href_upload_str.xpath("//p[contains(text(),'-')]")[0].text

    Href.new(title, url, nil, size_raw, nil, time_str + ' ' + date_str, query)
  end

  private

  def initialize(title, url, size, size_raw, upload_timestamp, upload_raw, query = nil)
    @title = title
    @url = url
    @query = query
    @size = size
    @size_raw = size_raw
    @upload_timestamp = upload_timestamp
    @upload_raw = upload_raw
  end
end
