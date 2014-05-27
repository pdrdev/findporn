# A search query
class Query
  attr_reader :value
  attr_reader :section
  attr_accessor :hrefs

  def initialize(value, section)
    @value = value
    @section = section
    @hrefs = []
  end
end
