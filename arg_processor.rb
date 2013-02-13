class ArgProcessor
  attr_accessor :do_login

  def initialize(args)
    @error = false
    @do_login = false

    if args.size == 0
      # default
      return
    end

    if args.size > 1
      @error = true
      @error_message = usage
      return
    end

    if (args[0] == '--do-login')
      @do_login = true
    else
      @error = true
      @error_message = "unknown argument: #{args[0]} \n" + usage
    end
  end

  def usage
    "usage: ruby script.rb [--do-login]"
  end

  def error?
    @error
  end

  def error_message
    @error_message
  end
end