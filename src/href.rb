require 'nokogiri'

class Href
  attr_accessor :title
  attr_accessor :url
  attr_accessor :id

  def initialize(href_str)
    @doc = href_str
    @title = @doc.text
    @url = @doc.get_attribute('href')
    @id = @doc.get_attribute('href').gsub(/[^\d]+/, '').to_i
  end

end