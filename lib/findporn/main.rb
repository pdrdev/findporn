# Main class
# Does things
class Main
  QUERIES_FILE_NAME = 'queries.txt'

  def initialize
    @opt_processor = OptProcessor.new ARGV
    @settings = Settings.new
    @pornolab_client = PornolabClient.new @settings
  end

  def run
    begin
      init_and_check_options

      start_time = Time.new
      Util.log("Started at #{start_time.inspect}", true)

      action = @opt_processor.action
      Util.log("Action: #{action}", true)

      case action
        when 'render'
          render
        when 'sync'
          sync
        when 'all'
          do_all
      end

      stop_time = Time.new
      Util.log("Stopped", true)
      Util.log("Stopped at #{stop_time.inspect}", true)
      Util.log("Execution time: #{stop_time - start_time} seconds", true)
    rescue Exception => e
      Util.log e.message.to_s
      Util.log e.backtrace
      exit 0
    end
  end

  private

  def render
    Util.log 'Executing action: render'
    sql_client = SqlClient.create
    porn_store = PornStore.load sql_client

    ResultRenderer.new.print_results porn_store
  end

  def sync
    Util.log 'Executing action: sync'

    if @opt_processor.do_login?
      # forced login
      @pornolab_client.login
    end
    query_doc = QueriesDoc.from_file_name Util.root + QUERIES_FILE_NAME

    store = PornStore.create query_doc, @pornolab_client
    store.save SqlClient.create
  end

  def do_all
    sync
    render
  end

  def init_and_check_options
    Util.opt_processor = @opt_processor
    if @opt_processor.error?
      raise FindpornException.new @opt_processor.error_message
    end
  end

  def get_hrefs_for_doc(query_doc)
    total_queries = query_doc.size
    i = 0
    query_doc.sections.each do |section|
      Util.log('##################################', true)
      Util.log("Processing section: #{if !section.name.empty? then section.name else 'Default' end}", true)
      Util.log('##################################', true)
      section.queries.each do |query|
        i += 1
        Util.log("Processing query: #{query} (#{i}/#{total_queries})", true)
        section.add_query_to_hrefs(query, @pornolab_client.find_hrefs(query + " " + section.append, @opt_processor.max_hrefs))
      end
    end
  end
end
