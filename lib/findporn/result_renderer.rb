require 'date'

class ResultRenderer
  RESULT_FILE_NAME = 'result.html'

  # TODO use templates or something
  def print_results(porn_store)
    Util.log 'Rendering results'

    File.open(Util.root + RESULT_FILE_NAME, 'w') do |f|
      print_header f
      porn_store.sections.each do |section|
        print_section f, section
      end
      print_footer f
    end
  end

  private
  def print_header(file)
    file.write '<!DOCTYPE html>'
    file.write '<html>'
    file.write '<head><meta http-equiv="content-type" content="text/html; charset=UTF-8"><script src="fp.js"></script></head>'
    file.write '<style type="text/css"> a:visited {color:gray;} body {background-color:white;} </style>'
    file.write '<body>'
    file.write "<input id='max_uploaded_days' size='10' /><button onclick='filterByDates()'>Filter</button> by max days since uploading"
    file.write "<br>"
    file.write "<input id='max_added_days' size='10' /><button onclick='filterByDates()'>Filter</button> by max days since adding"
    file.write "<br>"
    file.write "<input id='filter_empty_queries' type='checkbox' onclick='filterEmptyQueries()'/> Filter empty queries"
    file.write "<br>"
    file.write "<input id='filter_empty_sections' type='checkbox' onclick='filterEmptySections()'/> Filter empty sections"
  end

  def print_footer(file)
    file.write '</body></html>'
  end

  def print_section(file, section)
    file.write "<div class='section' active='#{section.active.to_s}'>"
    file.write "<h1>#{section.name}</h1>"
    section.queries.each do |query|
       print_query file, query
    end
    file.write "</div>"
  end

  def print_query(file, query)
    file.write "<div class='query' active='#{query.active.to_s}'>"
    file.write "<h3>#{query.value}</h3>"
    query.hrefs.each do |href|
      upload_date = DateTime.strptime(href.uploaded_timestamp.to_s, '%s')
      formatted_date = upload_date.strftime('%m/%d/%Y')
      file.write "<div class='href' uploaded_timestamp='#{href.uploaded_timestamp.to_s}' added_timestamp='#{href.added_timestamp.to_s}' active='#{href.active.to_s}'>"
      file.write "<a href='http://pornolab.net/forum/#{href.url}'>#{href.title}</a> Size: #{href.size_raw} Uploaded: #{formatted_date}"
      file.write '</div>'
    end
    file.write "</div>"
  end
end
