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

  # read queries.txt from the text file
  def get_queries
    text = File.open(Util.root + 'queries.txt').read # TODO handle errors
    lines = text.lines

    # removing comments
    lines = lines.map do |line|
      comment_index = line.index '#'
      if !comment_index.nil?
        line[0...comment_index]
      else
        line
      end
    end

    # removing empty lines
    lines = lines.select{|line| !line.nil? && !line.strip.empty?}
  end

  # TODO use templates or something
  def print_results(queries_doc)
    File.open(Util.root + "result.html", "w") do |f|
      f.write '<?xml version="1.0" encoding="UTF-8"?>'
      f.write("<html>")
      f.write '<head><meta http-equiv="content-type" content="text/html; charset=UTF-8"></head>'
      f.write '<style type="text/css"> a:visited {color:gray;} body {background-color:white;} </style>'
      f.write("<body>")
      queries_doc.sections.each do |section|
        f.write("<h1>#{section.name}</h1>")
        section.queries_to_hrefs.each do |query_to_hrefs|
          query = query_to_hrefs[:query]
          hrefs = query_to_hrefs[:hrefs]
          f.write("<h3>#{query}</h3>")
          hrefs.each do |href|
            f.write("<a href=http://pornolab.net/forum/#{href.url}>#{href.title}</a><br>")
          end

        end
        f.write("</body></html>")
      end
    end
  end
end
