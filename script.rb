require "find_porn"
require "arg_processor"

arg_processor = ArgProcessor.new(ARGV)
if arg_processor.error?
  puts arg_processor.error_message
  exit(0)
end

do_login = arg_processor.do_login
find_porn = FindPorn.new

if do_login
  find_porn.login
end

find_porn.do_search
