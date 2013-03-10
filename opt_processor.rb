# processing command line arguments
class OptProcessor
  DEFAULT_TO_LOGIN = false
  DEFAULT_VERBOSE = false
  DEFAULT_MAX_HREFS = 10

  def initialize(args)
    @error = false

    @options = {}
    op = OptionParser.new do |opts|
      opts.banner = "Usage: script.rb [options]"

      opts.on("-v", "--verbose", "Run verbosely") do |v|
        @options[:verbose] = v
      end

      opts.on("--do-login", "Force login") do |dl|
        @options[:do_login] = dl
      end

      opts.on("--max-hrefs N", Integer, "Maximum hrefs for one query") do |n|
        @options[:max_hrefs] = n
      end
    end

    begin op.parse! args
    rescue OptionParser::InvalidOption => e
      @error = true
      @error_message = e.to_s + "\n" + op.to_s
    end
  end

  def error?
    @error
  end

  def error_message
    @error_message
  end

  def do_login
    if @options.has_key?(:do_login)
      @options[:do_login]
    else
      DEFAULT_TO_LOGIN
    end
  end

  def verbose
    if @options.has_key?(:verbose)
      @options[:verbose]
    else
      DEFAULT_VERBOSE
    end
  end

  def max_hrefs
    if @options.has_key? :max_hrefs
      @options[:max_hrefs]
    else
      DEFAULT_MAX_HREFS
    end
  end
end