class CookieManager
  attr_accessor :packed_cookies

  def initialize
    @packed_cookies = nil
  end

  def get_cookies
    return @packed_cookies unless @packed_cookies.nil?
    read_cookies
  end

  def pack_cookies(cookie_array, save=true)
    cookie_hash = {}
    cookie_array.each { | cookie |
      trimmed = cookie.split('; ')[0]
      split = trimmed.split('=')
      cookie_hash[split[0]] = split[1]
    }

    #sort so order will be deterministic
    @packed_cookies = cookie_hash.map { |k, v| "#{k}=#{v}"}.sort.join('; ')
    save_cookies if save
    @packed_cookies
  end

  def save_cookies
    File.open("cookies", "w") do |f|
      f.write(@packed_cookies)
    end
  end

  def read_cookies
    res = ''
    File.open("cookies", "r") do |f|
      res = f.readline
    end
    res
  end
end
