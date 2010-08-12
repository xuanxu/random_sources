require 'open-uri'
providers_dir = File.dirname(__FILE__) + '/../lib/providers'
$LOAD_PATH.unshift(providers_dir)
Dir[File.join(providers_dir, "*.rb")].each {|file| require File.basename(file)}

module RandomSources
  
  def self.list
    self.constants*', '
  end  
  
  def self.generator(provider)
    return self.const_get(provider).new if self.constants.include?(provider.to_sym)
    raise NameError.new("Provider not available or name not recognized. Check the list of supported providers with RandomSources.list", provider.to_s) 
  end

end