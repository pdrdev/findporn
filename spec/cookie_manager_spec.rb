require 'rspec'
require 'net/http'

Dir[File.dirname(__FILE__) + '/../lib/findporn/*'].each {|file| require file.gsub('file:', '') }

describe CookieManager do

  before :each do
    @cookie_manager = CookieManager.new
  end

  it "set cookies" do
    server_response_mock = mock(Net::HTTPResponse)
    server_response_mock.stub!(:get_fields).and_return(
        [
            'phpbb3_r3qux_u=1; expires=Tue, 11-Feb-2014 01:34:32 GMT; path=/; HttpOnly',
            'phpbb3_r3qux_k=; expires=Tue, 11-Feb-2014 01:34:32 GMT; path=/; HttpOnly',
            'phpbb3_r3qux_sid=a93d1d77fcbb0b775901d8780d2768f3; expires=Tue, 11-Feb-2014 01:34:32 GMT; path=/; HttpOnly',
            'phpbb3_r3qux_u=2; expires=Tue, 11-Feb-2014 01:34:32 GMT; path=/; HttpOnly',
            'phpbb3_r3qux_k=; expires=Tue, 11-Feb-2014 01:34:32 GMT; path=/; HttpOnly',
            'phpbb3_r3qux_sid=cdd6ac5f35b45aa3b582d1320f13d680; expires=Tue, 11-Feb-2014 01:34:32 GMT; path=/; HttpOnly'
        ]
    )
    @cookie_manager.set_cookies_from_server_response(server_response_mock, false)
    @cookie_manager.get_cookies.should == 'phpbb3_r3qux_k=; phpbb3_r3qux_sid=cdd6ac5f35b45aa3b582d1320f13d680; phpbb3_r3qux_u=2'
  end


end
