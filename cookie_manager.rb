class CookieManager
  attr_accessor :packed_cookies

  def initialize
    @packed_cookies = ''
  end

  def pack_cookies(cookie_array)
    cookie_hash = {}
    cookie_array.each { | cookie |
      trimmed = cookie.split('; ')[0]
      split = trimmed.split('=')
      cookie_hash[split[0]] = split[1]
    }

    #sort so order will be deterministic
    @packed_cookies = cookie_hash.map { |k, v| "#{k}=#{v}"}.sort.join('; ')
  end
end
