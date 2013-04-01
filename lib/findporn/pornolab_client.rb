# Pornolab client
# Takes care of all pornolab-specific stuff
class PornolabClient
  MAX_LOGIN_ATTEMPTS = 2

  def initialize(settings)
    @cookie_manager = CookieManager.new
    @login_uri = URI(settings.get('protocol') + '://' + settings.get('host') + settings.get('login_path'))
    @search_host = settings.get('host')
    @search_path = settings.get('search_path')
    @login_args = {'mode' => 'login', settings.get('login_field_name') => settings.get('login'), settings.get('password_field_name') => settings.get('password'), 'login' => 'Login', 'redirect' => './index.php?'}
    @login_attempts = 0
  end

  def login
    if @login_attempts > MAX_LOGIN_ATTEMPTS
      raise FindpornException, "Login failed. Check your login and password."
    end
    @login_attempts += 1
    login_result = Net::HTTP.post_form(@login_uri, @login_args)
    unless check_login(login_result)
      Util.log("Login attempt failed. Retrying...", true)
      login
      return
    else
      Util.log("Login succeeded.", true)
    end
    @cookie_manager.set_cookies_from_server_response(login_result, true)
  end

  def find_hrefs(query, max_hrefs_per_query = 10)
    http = Net::HTTP.new(@search_host)
    response = http.post(@search_path, "max=1&to=1&nm=#{query}", {'Cookie' => @cookie_manager.get_cookies})
    unless check_login(response)
      login
      return find_hrefs(query)
    end
    doc = Nokogiri::HTML(response.body)
    doc.xpath("//a[@class='med tLink bold']").take(max_hrefs_per_query).map{|s| Href.new(s)}
  end

  private
  def check_captcha(doc)
    if captcha? doc
      raise FindpornException, "pornolab.net requires captcha. Please try again later."
    end
  end

  def captcha?(doc)
    !(doc.to_s.index "captcha").nil?
  end

  # assume login is successful if there's no "send password" element in response body
  def check_login(response)
    doc = Nokogiri::HTML(response.body)
    send_password_links = doc.xpath("//a[@href='profile.php?mode=sendpassword']")

    is_valid = @cookie_manager.has_valid_cookies?(response) || (send_password_links.empty? && !response.body.empty?)

    if is_valid
      return true
    end
    check_captcha doc
    false
  end
end
