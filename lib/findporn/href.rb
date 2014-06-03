# encoding: utf-8

# Parsing hyper references like
# <a class="med tLink bold" href="./viewtopic.php?t=1234">Some title</a>

require 'date'

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
    upload_str = time_str + ' ' + date_str

    parsed_date = self.to_date(time_str, date_str)

    Href.new(title, url, nil, size_raw, parsed_date.to_time.to_i, query)
  end

  private

  def self.to_date(time_str, date_str)
    date_str = date_str.gsub('Янв', '01').gsub('Фев', '02').gsub('Мар', '03').gsub('Апр', '04').
        gsub('Май', '05').gsub('Июн', '06').gsub('Июл', '07').gsub('Авг', '08').
        gsub('Сен', '09').gsub('Окт', '10').gsub('Ноя', '11').gsub('Дек', '12')

    day = date_str.split('-')[0].to_i
    month = date_str.split('-')[1].to_i
    year = ('20' + date_str.split('-')[2]).to_i

    hour = time_str.split(':')[0].to_i
    min = time_str.split(':')[1].to_i
    DateTime.new(year, month, day, hour, min)
  end

  def initialize(title, url, size, size_raw, upload_timestamp, query = nil)
    @title = title
    @url = url
    @query = query
    @size = size
    @size_raw = size_raw
    @upload_timestamp = upload_timestamp
  end
end
