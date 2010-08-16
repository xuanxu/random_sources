module RandomSources

  class RandomOrg
    attr_reader :website
    
    def initialize
      @website = "http://www.random.org/"
    end
    
    def info
      "RANDOM.ORG offers numbers with randomness coming from atmospheric noise.
      The service was built and is being operated by Mads Haahr of the School of Computer Science and Statistics at Trinity College, Dublin in Ireland."
    end
  
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

      begin
        response=open("#{@website}integers/?max=#{url_params[:max]}&min=#{url_params[:min]}&base=#{url_params[:base]}&col=#{url_params[:col]}&rnd=#{url_params[:rnd]}&format=#{url_params[:format]}&num=#{url_params[:num]}") 
        response.each_line{|line| numbers << line.to_i}
      rescue OpenURI::HTTPError => boom 
        raise StandardError.new("Error from server: "+boom.io.read.strip)   
      end
      
      numbers
    end
    
    def sequence(min, max)
      url_params = { :max => clean(max) || 10, 
                     :min => clean(min) || 1, 
                     :rnd => 'new',
                     :format => 'plain',
                     :col => 1
                   }
      sequence_numbers=[]

      begin
       response=open("#{@website}sequences/?max=#{url_params[:max]}&min=#{url_params[:min]}&col=#{url_params[:col]}&rnd=#{url_params[:rnd]}&format=#{url_params[:format]}") 
       response.each_line{|line| sequence_numbers << line.to_i}
      rescue OpenURI::HTTPError => boom 
       raise StandardError.new("Error from server: "+boom.io.read.strip)   
      end

      sequence_numbers
    end


    private 
    def clean(p)
      (p.nil? || p.to_s=='') ? nil : p.to_i
    end
    
  end  
end