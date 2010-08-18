require File.dirname(__FILE__) + '/spec_helper'

describe RandomSources::HotBits do
  
  describe 'Bytes generator' do

    before(:each) do
      @base_url = "https://www.fourmilab.ch/cgi-bin/Hotbits"
      @default_params = {'fmt' => 'xml', 'nbytes'=> 10}
      @default_query = get_url(@base_url, @default_params)
      @generator = RandomSources::HotBits.new
    end
  
    it "hits hotbits url with default query if no options provided" do
      @generator.stub!(:open).and_return(File.new("#{$data_samples_path}/hotbits_ok.xml"))
      @generator.should_receive(:open).with(@default_query)
      @generator.bytes.should include "A7".hex
    end

  end
  
end