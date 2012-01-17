module SimpleChat
  def self.[](key)
    unless @config
      @config = YAML::load(ERB.new(IO.read(Rails.root.join('config', 'app.yml'))).result)[Rails.env].symbolize_keys!
    end
    @config[key]
  end
  
  def self.[]=(key, value)
    @config[key.to_sym] = value
  end
  
end




