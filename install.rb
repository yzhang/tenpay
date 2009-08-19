dest_file = File.join(RAILS_ROOT, "config/tenpay.yml")
src_file = File.join(File.dirname(__FILE__) , 'config/tenpay.yml')
FileUtils.cp_r(src_file, dest_file)

puts IO.read(File.join(File.dirname(__FILE__), 'README'))