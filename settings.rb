require 'yaml'

class Settings
  def initialize
    # TODO No such file error handler
    @properties = YAML.load_file("config.yml")
  end

  def get(name)
    res = @properties[name]
    if res.nil?
      puts "Property #{name} doesn't exist in config.yml"
      abort()
    else
      @properties[name]
    end
  end
end
