require "find_porn"
require "opt_processor"
require "optparse"
require "util.rb"

opt_processor = OptProcessor.new(ARGV)
Util.opt_processor = opt_processor

def get_opt_processor
  opt_processor
end

if opt_processor.error?
  Util.log opt_processor.error_message
  exit(1)
end

Util.log("Started", true)

find_porn = FindPorn.new
if opt_processor.do_login
  find_porn.login
end
find_porn.do_search

Util.log("Stopped", true)
