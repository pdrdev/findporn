# kinda main class
# runs queries
class FindPorn

  def initialize(opt_processor)
    @opt_processor = opt_processor
    @config = Settings.new
    @pornolab_client = PornolabClient.new @config
  end

  def do_search
    query_doc = QueriesDoc.from_file_name Util.root + 'queries.txt'
    get_hrefs_for_doc query_doc
    print_results query_doc
  end

  def get_hrefs_for_doc(query_doc)
    query_doc.sections.each do |section|
      section.queries.each do |query|
        section.query_to_hrefs(query, @pornolab_client.find_hrefs(query + " " + section.append, @opt_processor.max_hrefs))
      end
    end
  end

  private
  def print_results(queries_doc)
    ResultRenderer.new.print_results queries_doc
  end
end
