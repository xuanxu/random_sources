
require File.dirname(__FILE__) + '/../lib/random_sources'
providers_dir = File.dirname(__FILE__) + '/../lib/providers'
$LOAD_PATH.unshift(providers_dir)
Dir[File.join(providers_dir, "*.rb")].each {|file| require File.basename(file)}
$data_samples_path = File.dirname(__FILE__) + '/data_samples'

def get_url(base_url, params_hash={}) #:nodoc:
  return "#{base_url}?#{params_hash.keys.inject([]){|q, key| q<<"#{key}=#{params_hash[key]}"}*'&'}"
end