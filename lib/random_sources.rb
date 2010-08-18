require 'open-uri'
providers_dir = File.dirname(__FILE__) + '/../lib/providers'
$LOAD_PATH.unshift(providers_dir)
Dir[File.join(providers_dir, "*.rb")].each {|file| require File.basename(file)}

module RandomSources
  # List of all the random sources providers supported
  #
  # It returns a string of names separated by commas. You can use any of the names to instantiate a class with the <tt>generator</tt> method
  def self.list
    self.constants*', '
  end  
  
  # Instantiate and returns the class managing the online provider specified as param.
  # 
  # If you don't know the names of the providers you can get them via the <tt>list</tt> method.
  def self.generator(provider)
    return self.const_get(provider).new if self.constants.include?(provider.to_sym)
    raise NameError.new("Provider not available or name not recognized. Check the list of supported providers with RandomSources.list", provider.to_s) 
  end

end