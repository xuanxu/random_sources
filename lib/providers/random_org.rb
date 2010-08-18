module RandomSources
  
  # The RandomOrg class uses the http service provided by http://www.random.org.
  #
  # RANDOM.ORG offers numbers with randomness coming from atmospheric noise.
  #
  # The service assigns a daily quota of available random bits for IP.
  #
  # Use the service properly and check the website if you need more details about the terms of usage.
  class RandomOrg
    attr_reader :website
    
    def initialize
      @website = "http://www.random.org/"
    end
    
    # Short info about the online source.
    def info
      "RANDOM.ORG offers numbers with randomness coming from atmospheric noise.
      The service was built and is being operated by Mads Haahr of the School of Computer Science and Statistics at Trinity College, Dublin in Ireland."
    end
  
    # Random Integers Generator.
    # 
    # Configuration options:
    # * <tt>:num</tt> - The number of integers requested. Posibles values: [1,1e4]. Default: 10
    # * <tt>:min</tt> - The smallest value allowed for each integer. Posibles values: [-1e9,1e9]. Default: 1
    # * <tt>:max</tt> - The smallest value allowed for each integer. Posibles values: [-1e9,1e9]. Default: 100
    # * <tt>:base</tt> - The base that will be used to print the numbers. Posibles values: 2, 8, 10, 16 (binary, octal, decimal or hexadecimal). Default: 10
    #
    # It returns an Array of integers with the size indicated by <tt>:num</tt>
    #
    #   integers(:num => 15, :max => 2, :min => 200, base => 8)  #=> array of 15 base 8 numbers between 2 and 200
    #   integers(:num => 4, :max => 33)                          #=> [31, 25, 28, 6]
    #
    def integers(options = {})
      url_params = { :max => clean(options[:max]) || 100, 
                     :min => clean(options[:min]) || 1, 
                     :num => clean(options[:num]) || 10, 
                     :base => clean(options[:base]) || 10, 
                     :rnd => 'new',
                     :format => 'plain',
                     :col => 1
                   }

      numbers=[]

      check_for_http_errors{
        response=open("#{@website}integers/?max=#{url_params[:max]}&min=#{url_params[:min]}&base=#{url_params[:base]}&col=#{url_params[:col]}&rnd=#{url_params[:rnd]}&format=#{url_params[:format]}&num=#{url_params[:num]}") 
        response.each_line{|line| numbers << line.to_i}
      }
      
      numbers
    end
    
     # The Sequence Generator
     # 
     # It will randomize a given interval of integers, i.e., arrange them in random order.
     # 
     # It needs two params:
     # * <tt>min</tt> - The lower bound of the interval (inclusive). Posibles values: [-1e9,1e9]
     # * <tt>max</tt> - The upper bound of the interval (inclusive). Posibles values: [-1e9,1e9]
     #
     # The length of the sequence (the largest minus the smallest value plus 1) can be no greater than 10,000.
     #
     # It returns an Array of all the integers of the given interval arranged randomly
     # 
     #   sequence(2, 15)  #=> [13, 2, 10, 4, 9, 15 ,12, 3, 5, 7, 6, 14, 8, 11]
    def sequence(min, max)
      url_params = { :max => clean(max) || 10, 
                     :min => clean(min) || 1, 
                     :rnd => 'new',
                     :format => 'plain',
                     :col => 1
                   }
      sequence_numbers=[]

      check_for_http_errors{
       response=open("#{@website}sequences/?max=#{url_params[:max]}&min=#{url_params[:min]}&col=#{url_params[:col]}&rnd=#{url_params[:rnd]}&format=#{url_params[:format]}")
       response.each_line{|line| sequence_numbers << line.to_i}
      }

      sequence_numbers
    end
    
    # Random Strings Generator.
    # 
    # It will generate truly random strings of various length and character compositions.
    #
    # Configuration options:
    # * <tt>:num</tt> - The number of strings requested. Posibles values: [1,1e4]. Default: 10
    # * <tt>:len</tt> - The length of the strings. All the strings produced will have the same length. Posibles values: [1,20]. Default: 8
    # * <tt>:digits</tt> - Determines whether digits (0-9) are allowed to occur in the strings. Posibles values: ['on', 'off']. Default: on
    # * <tt>:upperalpha</tt> - Determines whether uppercase alphabetic characters (A-Z) are allowed to occur in the strings. Posibles values: ['on', 'off']. Default: on
    # * <tt>:loweralpha</tt> - Determines lowercase alphabetic characters (a-z) are allowed to occur in the strings. Posibles values: ['on', 'off']. Default: on
    # * <tt>:unique</tt> - Determines whether the strings picked should be unique (as a series of raffle tickets drawn from a hat) or not (as a series of die rolls). 
    # If unique is set to on, then there is the additional constraint that the number of strings requested (num) must be less than or equal to the number of strings 
    # that exist with the selected length and characters. Posibles values: ['on', 'off']. Default: on
    # 
    # It returns an Array of Strings of the size indicated with <tt>:num</tt>
    # 
    #   strings(:num => 15, :len => 2, :digits => 'off', upperalpha => 'off')  #=> array of 15 strings of size 2 composed by diggits and lowercase letters with no repetition.
    #   strings(:num => 4, :len => 10)                                         #=> ["iloqQz2nGa", "D2mgs12kD6", "yMe1eDsinJ", "ZQPaEol6xr"]
    def strings(options = {})
      url_params = { :num => clean(options[:num]) || 10,
                     :len => clean(options[:len]) || 8, 
                     :digits => check_on_off(options[:digits]) || 'on',
                     :unique => check_on_off(options[:unique]) || 'on',
                     :upperalpha => check_on_off(options[:upperalpha]) || 'on',
                     :loweralpha => check_on_off(options[:loweralpha]) || 'on',
                     :rnd => 'new',
                     :format => 'plain'
                   }

      strings=[]

      check_for_http_errors{
        response=open("#{@website}strings/?num=#{url_params[:num]}&len=#{url_params[:len]}&digits=#{url_params[:digits]}&unique=#{url_params[:unique]}&upperalpha=#{url_params[:upperalpha]}&loweralpha=#{url_params[:loweralpha]}&rnd=#{url_params[:rnd]}&format=#{url_params[:format]}") 
        response.each_line{|line| strings << line.strip}
      }
      
      strings
    end
    
    # The Quota Checker.
    #
    # This method allows you to examine your quota at any point in time. 
    # The quota system of random.org works on the basis of IP addresses. 
    # Each IP address has a base quota of 1,000,000 daily bits.
    #
    # If your quota is greater than or equal to zero, the next request for random numbers will be fully completed, even if the request will result in the quota becoming negative. 
    # Hence, no partial responses will be sent as a result of exhausting ehe quota; the server will either return a full response or an error response.
    #
    # Every day, shortly after midnight UTC, all quotas with less than 1,000,000 bits receive a free top-up of 200,000 bits. 
    # If the server has spare capacity, you may get an additional free top-up earlier, but you should not count on it.
    # If you need extra bits urgently (or require many bits) you can purchase once-off top-ups from the Quota Page: http://www.random.org/quota.
    #
    # The method returns the number of bits left of your quota as an integer.
    def quota
      url_params = { :format => 'plain' }
      check_for_http_errors{
       response=open("#{@website}quota/?format=#{url_params[:format]}") 
       return response.to_i
      }
    end

    private 

    def clean(p) #:nodoc:
      (p.nil? || p.to_s=='') ? nil : p.to_i
    end
    
    def check_on_off(p) #:nodoc:
      return nil if p.nil?
      ['ON', 'OFF'].include?(p.upcase) ? p : nil 
    end  
    
    def check_for_http_errors #:nodoc:
      begin
        yield
      rescue OpenURI::HTTPError => boom 
       raise StandardError.new("Error from server: "+boom.io.read.strip)   
      end
    end
    
  end
  
end