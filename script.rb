#!/usr/bin/ruby

require "find_porn"
require "opt_processor"
require "optparse"
require "util.rb"


def get_opt_processor
  opt_processor
end


# init opt processor (parse command line arguments)
opt_processor = OptProcessor.new(ARGV)
Util.opt_processor = opt_processor

if opt_processor.error?
  Util.log opt_processor.error_message
  exit(1)
end

start_time = Time.new
Util.log("Started at #{start_time.inspect}", true)

find_porn = FindPorn.new
if opt_processor.do_login
  # forced login
  find_porn.login
end
find_porn.do_search

stop_time = Time.new
Util.log("Stopped", true)
Util.log("Stopped at #{stop_time.inspect}", true)
Util.log("Execution time: #{stop_time - start_time} seconds", true)
