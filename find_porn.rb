require 'net/http'
require 'settings'
require 'cookie_manager'

class FindPorn

  def initialize
    @cookie_manager = CookieManager.new
    @config = Settings.new
    @login_uri = URI(@config.get('protocol') + '://' + @config.get('host') + @config.get('login_path'))
    @search_host = @config.get('host')
    @search_path = @config.get('search_path')
    @login_args = {'mode' => 'login', @config.get('login_field_name') => @config.get('login'), @config.get('password_field_name') => @config.get('password'), 'login' => 'Login', 'redirect' => './index.php?'}
  end

  def get_cookies(result)
    all_cookies = result.get_fields('Set-cookie')
    @cookie_manager.pack_cookies(all_cookies)
  end

  def login_and_save_cookies
    login_result = Net::HTTP.post_form(@login_uri, @login_args)
    cookies = get_cookies(login_result)
    puts cookies
    File.open("cookies", "w") do |f|
      f.write(cookies)
    end
  end

  def read_cookies
    res = ''
    File.open("cookies", "r") do |f|
      res = f.readline
    end
    res
  end

  def do_search
    http = Net::HTTP.new(@search_host)
    response = http.post(@search_path, "max=1&to=1&nm=search_string&start=50", {'Cookie' => @cookie_manager.packed_cookies})
    write_result(response)
  end

  def write_result (result)
    File.open("result.html", 'w') do |f|
      f.write(result.body)
    end
  end
end