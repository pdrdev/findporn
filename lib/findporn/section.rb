class Section
  attr_accessor :name
  attr_accessor :append
  attr_accessor :queries
  attr_accessor :id
  attr_accessor :active

  def initialize(name, append, active)
    @name = name
    @append = append
    @active = active
    @queries = []
  end

  def add_query(query)
    @queries << query
  end
end
