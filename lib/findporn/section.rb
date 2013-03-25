class Section
  attr_accessor :name
  attr_accessor :append
  attr_accessor :queries
  attr_accessor :queries_to_hrefs

  def initialize(name, append)
    @name = name
    @append = append
    @queries = []
    @queries_to_hrefs = []
  end

  def add_query(query)
    @queries << query
  end

  def query_to_hrefs(query, hrefs)
    @queries_to_hrefs << {:query => query, :hrefs => hrefs}
  end
end