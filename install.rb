# Install hook code here
require 'ftools'
File.copy('config/tenpay.yml', File.expand_path(File.dirname(__FILE__) + "/../../../config/tenpay.yml"))