module Tenpay
  class Config
    require 'yaml'

    cattr_reader :spid, :key

    def self.load_config
      filename = "#{RAILS_ROOT}/config/tenpay.yml"
      file = File.open(filename)
      config = YAML.load(file)

      @@spid     = config[RAILS_ENV]['spid']
      @@key = config[RAILS_ENV]['key']
      
      unless @@spid && @@key
        raise "Please configure your Tenpay settings in #{filename}."
      end
    end
  end
end