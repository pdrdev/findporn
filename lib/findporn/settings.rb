class Settings
  def initialize
    # TODO No such file error handler
    @properties = YAML.load_file(Util.root + "config.yml")
  end

  def get(name)
    res = @properties[name]
    if res.nil?
      raise FindpornException, "Property #{name} doesn't exist in config.yml"
    else
      @properties[name]
    end
  end
end
