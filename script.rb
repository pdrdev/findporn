require "find_porn"

DO_LOGIN = true
find_porn = FindPorn.new

if DO_LOGIN
  find_porn.login_and_save_cookies
end

find_porn.do_search
