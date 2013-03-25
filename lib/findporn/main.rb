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
    init_and_check_options

    start_time = Time.new
    Util.log("Started at #{start_time.inspect}", true)

    if @opt_processor.do_login
      # forced login
      @pornolab_client.login
    end
    query_doc = QueriesDoc.from_file_name Util.root + QUERIES_FILE_NAME
    get_hrefs_for_doc query_doc
    print_results query_doc

    stop_time = Time.new
    Util.log("Stopped", true)
    Util.log("Stopped at #{stop_time.inspect}", true)
    Util.log("Execution time: #{stop_time - start_time} seconds", true)
  end

  private

  def init_and_check_options
    Util.opt_processor = @opt_processor
    if @opt_processor.error?
      Util.log @opt_processor.error_message
      java.lang.System.exit(0)
    end
  end

  def get_hrefs_for_doc(query_doc)
    query_doc.sections.each do |section|
      section.queries.each do |query|
        section.query_to_hrefs(query, @pornolab_client.find_hrefs(query + " " + section.append, @opt_processor.max_hrefs))
      end
    end
  end

  def print_results(queries_doc)
    ResultRenderer.new.print_results queries_doc
  end
end
