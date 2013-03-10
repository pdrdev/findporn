# processing command line arguments
class OptProcessor
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
    @options.has_key?(:do_login) && @options[:do_login]
  end

  def verbose
    @options.has_key?(:verbose) && @options[:verbose]
  end
end
