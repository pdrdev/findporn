lib = File.dirname(__FILE__).gsub('file:', '') # jruby adds 'file:' prefix for some reason

require lib + '/findporn/' + 'cookie_manager'
require lib + '/findporn/' + 'href'
require lib + '/findporn/' + 'main'
require lib + '/findporn/' + 'opt_processor'
require lib + '/findporn/' + 'pornolab_client'
require lib + '/findporn/' + 'queries_doc'
require lib + '/findporn/' + 'result_renderer'
require lib + '/findporn/' + 'section'
require lib + '/findporn/' + 'settings'
require lib + '/findporn/' + 'settings'
require lib + '/findporn/' + 'util'

require 'optparse'
require 'yaml'
require 'net/http'

require 'nokogiri'

Main.new.run