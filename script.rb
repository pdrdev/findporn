require 'settings.rb'
require 'net/http'

config = Settings.new
TEST = true
DO_LOGIN = true

login_url = config.get('protocol') + '://' + config.get('host') + config.get('login_path')
search_host = config.get('host')
search_path = config.get('search_path')
login_args = {'mode' => 'login', config.get('login_field_name') => config.get('login'), config.get('password_field_name') => config.get('password'), 'login' => 'Login', 'redirect' => './index.php?'}

def write_result (result)
  File.open("result.html", 'w') do |f|
    f.write(result.body)
  end
end

def get_cookies(result)
  all_cookies = result.get_fields('Set-cookie')
  cookies_array = Array.new
  i = 0
  all_cookies.each { | cookie |
    i += 1
    if (i > 3) or !TEST then
      cookies_array.push(cookie.split('; ')[0])
    end
  }
  cookies = cookies_array.join('; ')
  cookies
end

def login_and_save_cookies(login_uri, login_args)
  login_result = Net::HTTP.post_form(login_uri, login_args)
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

def do_search(search_host, search_path, cookies)
  http = Net::HTTP.new(search_host)
  response = http.post(search_path, "max=1&to=1&nm=search_string&start=50", {'Cookie' => cookies})
  write_result(response)
end


if DO_LOGIN
  login_uri = URI(login_url)
  login_and_save_cookies(login_uri, login_args)
end

cookies = read_cookies
do_search(search_host, search_path, cookies)
