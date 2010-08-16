require File.dirname(__FILE__) + '/spec_helper'
require 'open-uri'
require 'net/http'

describe RandomSources::RandomOrg do
  
  describe 'Integers generator' do

    before(:each) do
      @base_url = "http://www.random.org/integers/"
      @default_params = {'max' => 100, 
                         'min' => 1, 
                         'base' => 10, 
                         'col' => 1, 
                         'rnd' => 'new', 
                         'format' => 'plain', 
                         'num' => 10 }
      @default_query = get_url(@base_url, @default_params)
      @default_response = "4\n 8\n 15\n 16\n 23\n 33\n 42\n"
      @generator = RandomSources::RandomOrg.new
      @generator.stub!(:open).and_return(@default_response)
    end
  
    it "hits random_org url with default query if no options provided" do
      @generator.should_receive(:open).with(@default_query).and_return(@default_response)
      @generator.integers
    end
    
    it "hits random_org url with provided options" do
      @generator.should_receive(:open).with( get_url(@base_url,
                                             @default_params.merge({'max'=>50, 'min'=>3, 'num'=>4})) ).and_return(@default_response)
      @generator.integers(:max => 50, :min => 3, :num => 4)
    end
    
    it "returns an Array of integers" do
      @generator.integers.class.should == Array
      @generator.integers.size.should == 7
      @generator.integers.first.should == 4
    end
    
    it "raises an exception with the message from the server in case of a http error response" do
      exc = OpenURI::HTTPError.new("Error 503", StringIO.new("Wrong query params"))
      @generator.stub!(:open).and_raise(exc)
      lambda{@generator.integers(:max=>-12000000)}.should raise_exception{|e| e.message.should == "Error from server: Wrong query params"}
    end
    
    it "do not let user modify format, col or rnd query params" do
      @generator.should_receive(:open).with( get_url(@base_url,
                                             @default_params.merge({'max'=>50, 'min'=>3, 'num'=>4})) ).and_return(@default_response)
      @generator.integers(:max => 50, :min => 3, :num => 4, :col => 4, :rnd => 'changed', :format => 'html')
    end
    
    it "is protected against sql injection" do
      @generator.should_receive(:open).with(@default_query).and_return(@default_response)
      @generator.integers(:max => "100' OR 1=1")
    end
    
    
  end
end