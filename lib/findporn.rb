lib = File.expand_path(File.dirname(__FILE__)).gsub('file:', '') # jruby adds 'file:' prefix for some reason

require lib + '/findporn/' + 'util'

require lib + '/findporn/' + 'cookie_manager'
require lib + '/findporn/' + 'href'
require lib + '/findporn/' + 'findporn_exception'
require lib + '/findporn/' + 'main'
require lib + '/findporn/' + 'opt_processor'
require lib + '/findporn/' + 'pornolab_client'
require lib + '/findporn/' + 'queries_doc'
require lib + '/findporn/' + 'result_renderer'
require lib + '/findporn/' + 'section'
require lib + '/findporn/' + 'settings'
require lib + '/findporn/' + 'settings'
require lib + '/findporn/' + 'sql_client'

require 'optparse'
require 'yaml'
require 'net/http'

require 'nokogiri'

require 'sqlite3'

Main.new.run
