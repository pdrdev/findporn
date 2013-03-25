class ResultRenderer
  RESULT_FILE_NAME = 'result.html'

  # TODO use templates or something
  def print_results(queries_doc)
    File.open(Util.root + RESULT_FILE_NAME, 'w') do |f|
      print_header f
      queries_doc.sections.each do |section|
        print_section f, section
      end
      print_footer f
    end
  end

  private
  def print_header(file)
    file.write '<?xml version="1.0" encoding="UTF-8"?>'
    file.write '<html>'
    file.write '<head><meta http-equiv="content-type" content="text/html; charset=UTF-8"></head>'
    file.write '<style type="text/css"> a:visited {color:gray;} body {background-color:white;} </style>'
    file.write '<body>'
  end

  def print_footer(file)
    file.write '</body></html>'
  end

  def print_section(file, section)
    file.write "<h1>#{section.name}</h1>"
    section.queries_to_hrefs.each do |query_to_hrefs|
       print_hrefs_for_query file, query_to_hrefs[:query], query_to_hrefs[:hrefs]
    end
  end

  def print_hrefs_for_query(file, query, hrefs)
    file.write "<h3>#{query}</h3>"
    hrefs.each do |href|
      file.write "<a href=http://pornolab.net/forum/#{href.url}>#{href.title}</a><br>"
    end
  end
end
