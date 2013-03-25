# cookies are stored in 'cookies' text file
class CookieManager
  COOKIES_FILE_NAME = 'cookies'

  def initialize
    @packed_cookies = nil
  end

  def get_cookies
    return @packed_cookies unless @packed_cookies.nil?
    read_cookies
  end

  # save cookies
  def set_cookies_from_server_response(server_response, save_to_file=true)
    cookie_array = server_response.get_fields('Set-cookie')
    cookie_hash = cookie_array_to_hash(cookie_array)

    #sort so order will be deterministic
    @packed_cookies = cookie_hash.map { |k, v| "#{k}=#{v}"}.sort.join('; ')
    save_cookies_to_file if save_to_file
  end

  def has_valid_cookies?(response)
    response != nil && response.get_fields('Set-cookie') != nil && !response.get_fields('Set-cookie').empty? && valid_cookies?(response.get_fields('Set-cookie'))
  end

  private

  def valid_cookies?(cookie_array)
    cookie_hash = cookie_array_to_hash(cookie_array)
    cookie_hash.has_key?('bb_data') && cookie_hash['bb_data'] != 'deleted'
  end

  def cookie_array_to_hash(cookie_array)
    cookie_hash = {}
    cookie_array.each { | cookie |
      trimmed = cookie.split('; ')[0]
      split = trimmed.split('=')
      cookie_hash[split[0]] = split[1]
    }
    cookie_hash
  end

  def save_cookies_to_file
    File.open(Util.root + COOKIES_FILE_NAME, "w") do |f|
      f.write(@packed_cookies)
    end
  end

  def read_cookies
    unless File.exists?(Util.root + COOKIES_FILE_NAME)
      return ''
    end
    res = ''
    File.open(Util.root + COOKIES_FILE_NAME, "r") do |f|
      res = f.readline
    end
    res
  end
end
