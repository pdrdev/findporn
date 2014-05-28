class PornStore
  attr_reader :sections

  def self.create(queries_doc, pornolab_client)
    Util.log 'Creating PornStore'

    i = 0
    total_queries = queries_doc.size

    sections = queries_doc.sections

    sections.each do |section|
      Util.log('##################################', true)
      Util.log("Processing section: #{if !section.name.empty? then section.name else 'Default' end}", true)
      Util.log('##################################', true)
      section.queries.each do |query|
        i += 1
        Util.log("Processing query: #{query.value} (#{i}/#{total_queries})", true)

        hrefs = pornolab_client.find_hrefs query
        query.hrefs = hrefs
      end
    end

    PornStore.new sections
  end

  def self.load(db_client)
    Util.log 'Loading PornStore'
    db_client.load_porn_store
  end

  def save(db_client)
    Util.log 'Saving PornStore'
    db_client.save_porn_store self
  end

  def initialize(sections)
    @sections = sections
  end
end
