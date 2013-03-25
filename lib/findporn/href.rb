class Href
  attr_reader :title
  attr_reader :url
  attr_reader :id

  def initialize(href_str)
    @doc = href_str
    @title = @doc.text
    @url = @doc.get_attribute('href')
    @id = @doc.get_attribute('href').gsub(/[^\d]+/, '').to_i
  end

end