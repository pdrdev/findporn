# Parsing hyper references like
# <a class="med tLink bold" href="./viewtopic.php?t=1234">Some title</a>
class Href
  attr_reader :title
  attr_reader :url

  def self.create(href_str)
    doc = href_str
    title = doc.text
    url = doc.get_attribute('href')

    Href.new(title, url)
  end

  private

  def initialize(title, url)
    @title = title
    @url = url
  end
end
