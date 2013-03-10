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
    @login_attempted = false
  end

  def login
    if @login_attempted
      puts "Login failed. Check your login and password."
      exit(1)
    end
    login_result = Net::HTTP.post_form(@login_uri, @login_args)
    if !check_login(login_result)
      puts "Login attempt failed. Retrying..."
      login
      return
    else
      puts "Login succeeded."
    end
    @cookie_manager.pack_cookies(login_result.get_fields('Set-cookie'), true)
    @login_attempted = true
  end

  def check_login(response)
    doc = Nokogiri::HTML(response.body)
    send_password_links = doc.xpath("//a[@href='profile.php?mode=sendpassword']")
    return @cookie_manager.has_valid_cookies?(response) || (send_password_links.empty? && !response.body.empty?)
  end

  def do_search
    queries = get_queries
    hrefs_for_queries = []
    queries.each do |query|
      hrefs_for_queries << {:query => query, :hrefs => find_hrefs(query)}
    end
    print_results hrefs_for_queries
  end

  def find_hrefs(query)
    http = Net::HTTP.new(@search_host)
    response = http.post(@search_path, "max=1&to=1&nm=#{query}", {'Cookie' => @cookie_manager.get_cookies})
    if !check_login(response)
      login
      return find_hrefs(query)
    end
    doc = Nokogiri::HTML(response.body)
    doc.xpath("//a[@class='med tLink bold']").take(10).map{|s| Href.new(s)}
  end

  def get_queries
    text = File.open('queries').read # TODO handle errors
    text.lines.select{|line| !line.strip!.empty?}
  end

  def print_results(hrefs_for_queries)
    File.open("result.html", "w") do |f|
      f.write '<?xml version="1.0" encoding="UTF-8"?>'
      f.write("<html>")
      f.write '<head><meta http-equiv="content-type" content="text/html; charset=UTF-8"></head>'
      f.write("<body>")
      hrefs_for_queries.each do |hrefs_for_query|
        f.write("<h3>#{hrefs_for_query[:query]}</h3>")
        hrefs_for_query[:hrefs].each do |href|
          f.write("<a href=http://pornolab.net/forum/#{href.url}>#{href.title}</a><br>")
        end
      end
      f.write("</body></html>")
    end
  end
end