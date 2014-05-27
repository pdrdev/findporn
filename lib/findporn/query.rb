# A search query
class Query
  attr_reader :value
  attr_reader :section
  attr_accessor :hrefs
  attr_accessor :id

  def initialize(value, section)
    @value = value
    @section = section
    @hrefs = []
  end
end
