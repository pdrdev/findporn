class Section
  attr_accessor :name
  attr_accessor :append
  attr_accessor :queries

  def initialize(name, append)
    @name = name
    @append = append
    @queries = []
  end

  def add_query(query)
    @queries << query
  end
end
