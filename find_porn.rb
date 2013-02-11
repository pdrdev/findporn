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

  def login
    login_result = Net::HTTP.post_form(@login_uri, @login_args)
    @cookie_manager.pack_cookies(login_result.get_fields('Set-cookie'), true)
  end

  def do_search
    http = Net::HTTP.new(@search_host)
    response = http.post(@search_path, "max=1&to=1&nm=search_string&start=50", {'Cookie' => @cookie_manager.get_cookies})
    write_result(response)
  end

  def write_result (result)
    File.open("result.html", 'w') do |f|
      f.write(result.body)
    end
  end
end