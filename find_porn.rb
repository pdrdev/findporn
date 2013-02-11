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
  end

  def find_hrefs(query)
    http = Net::HTTP.new(@search_host)
    response = http.post(@search_path, "max=1&to=1&nm=#{query}&start=50", {'Cookie' => @cookie_manager.get_cookies})
    doc = Nokogiri::HTML(response.body)
    doc.xpath("//a[@class='med tLink bold']").map{|s| Href.new(s)}
  end

  def write_result (result)
    File.open("result.html", 'w') do |f|
      f.write(result.body)
    end
  end
end