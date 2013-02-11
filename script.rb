require "find_porn"

DO_LOGIN = false
find_porn = FindPorn.new

if DO_LOGIN
  find_porn.login
end

find_porn.do_search
