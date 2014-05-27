# Parsing hyper references like
# <a class="med tLink bold" href="./viewtopic.php?t=1234">Some title</a>
class Href
  attr_reader :title
  attr_reader :url
  attr_reader :query
  attr_accessor :id

  def self.create(href_str, query = nil)
    doc = href_str
    title = doc.text
    url = doc.get_attribute('href')

    Href.new(title, url, query)
  end

  private

  def initialize(title, url, query = nil)
    @title = title
    @url = url
    @query = query
  end
end
