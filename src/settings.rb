class Settings
  def initialize
    # TODO No such file error handler
    @properties = YAML.load_file(Util.root + "config.yml")
  end

  def get(name)
    res = @properties[name]
    if res.nil?
      Util.log "Property #{name} doesn't exist in config.yml"
      exit(1)
    else
      @properties[name]
    end
  end
end
