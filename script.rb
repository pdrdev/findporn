require "find_porn"
require "opt_processor"
require "optparse"

opt_processor = OptProcessor.new(ARGV)
if opt_processor.error?
  puts opt_processor.error_message
  exit(1)
end

do_login = opt_processor.do_login
find_porn = FindPorn.new

if do_login
  find_porn.login
end

find_porn.do_search
