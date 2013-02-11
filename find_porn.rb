require 'rubygems'
require 'net/http'
require 'nokogiri'

require 'settings'
require 'cookie_manager'
require 'href'

class FindPorn

  def initialize
    @cookie_manager = CookieManager.new
    @config = Settings.new
    @login_uri = URI(@config.get('protocol') + '://' + @config.get('host') + @config.get('login_path'))
    @search_host = @config.get('host')
    @search_path = @config.get('search_path')
    @login_args = {'mode' => 'login', @config.get('login_field_name') => @config.get('login'), @config.get('password_field_name') => @config.get('password'), 'login' => 'Login', 'redirect' => './index.php?'}
  end

  def login
    login_result = Net::HTTP.post_form(@login_uri, @login_args)
    @cookie_manager.pack_cookies(login_result.get_fields('Set-cookie'), true)
  end

  def do_search
    queries = get_queries
    queries_to_hrefs = {}
    queries.each do |query|
      queries_to_hrefs[query] = find_hrefs(query)
    end
    print_results queries_to_hrefs
  end

  def find_hrefs(query)
    http = Net::HTTP.new(@search_host)
    response = http.post(@search_path, "max=1&to=1&nm=#{query}", {'Cookie' => @cookie_manager.get_cookies})
    doc = Nokogiri::HTML(response.body)
    doc.xpath("//a[@class='med tLink bold']").take(10).map{|s| Href.new(s)}
  end

  def get_queries
    text = File.open('queries').read # TODO handle errors
    text.lines.select{|line| !line.strip!.empty?}
  end

  def print_results(queries_to_hrefs)
    File.open("result.html", "w") do |f|
      f.write '<?xml version="1.0" encoding="UTF-8"?>'
      f.write("<html>")
      f.write '<head><meta http-equiv="content-type" content="text/html; charset=UTF-8"></head>'
      f.write("<body>")
      queries_to_hrefs.each do |query, hrefs|
        f.write("<h3>#{query}</h3>")
        hrefs.each do |href|
          f.write("<a href=http://pornolab.net/forum/#{href.url}>#{href.title}</a><br>")
        end
      end
      f.write("</body></html>")
    end
  end
end