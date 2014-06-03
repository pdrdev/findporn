# A search query
class Query
  attr_reader :value
  attr_reader :section
  attr_accessor :hrefs
  attr_accessor :id
  attr_accessor :active

  def initialize(value, section, active)
    @value = value
    @section = section
    @active = active
    @hrefs = []
  end
end
