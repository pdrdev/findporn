# processing command line arguments
class OptProcessor
  DEFAULT_TO_LOGIN = false
  DEFAULT_VERBOSE = false
  DEFAULT_MAX_HREFS = 10
  DEFAULT_ACTION = 'all'

  def initialize(args)
    @error = false

    @options = {}
    op = OptionParser.new do |opts|
      opts.banner = "Usage: findporn [options]"

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
    rescue OptionParser::InvalidOption => parseException
      @error = true
      @error_message = parseException.to_s + "\n" + op.to_s
    rescue Exception
    end

    if !args.empty? then
      action = args.pop
      if ['all', 'sync', 'render'].include? action then
        @options[:action] = action
      else
        @error = true
        @error_message = "Action is not supported: #{action}"
      end
    end
  end

  def error?
    @error
  end

  def error_message
    @error_message
  end

  # force login
  def do_login?
    if @options.has_key?(:do_login)
      @options[:do_login]
    else
      DEFAULT_TO_LOGIN
    end
  end

  def verbose?
    if @options.has_key?(:verbose)
      @options[:verbose]
    else
      DEFAULT_VERBOSE
    end
  end

  # Maximum hrefs for one query
  def max_hrefs
    if @options.has_key? :max_hrefs
      @options[:max_hrefs]
    else
      DEFAULT_MAX_HREFS
    end
  end

  # Action
  def action
    if @options.has_key? :action
      @options[:action]
    else
      DEFAULT_ACTION
    end
  end
end
