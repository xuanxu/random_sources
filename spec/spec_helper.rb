require File.dirname(__FILE__) + '/../lib/random_sources'
providers_dir = File.dirname(__FILE__) + '/../lib/providers'
$LOAD_PATH.unshift(providers_dir)
Dir[File.join(providers_dir, "*.rb")].each {|file| require File.basename(file)}