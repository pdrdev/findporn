module Util extend self
  # initialized in main file
  attr_accessor :opt_processor

  def self.log(message, verbose=false)
    if !opt_processor.nil? && (!verbose || @opt_processor.verbose?)
      puts message
    end
  end

  def self.root
    File.dirname(__FILE__) + "/../../"
  end
end
