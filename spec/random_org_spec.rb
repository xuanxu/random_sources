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
  
  describe 'Sequence generator' do 
    before(:each) do
      @base_url = "http://www.random.org/sequences/"
      @default_params = {'max' => 10, 
                         'min' => 1, 
                         'col' => 1, 
                         'rnd' => 'new', 
                         'format' => 'plain'}
      @default_query = get_url(@base_url, @default_params)
      @default_response = "8\n 10\n 4\n 1\n 6\n 2\n 3\n 9\n 5\n 7\n"
      @generator = RandomSources::RandomOrg.new
      @generator.stub!(:open).and_return(@default_response)
    end
    
    it "hits random_org url with default query if no options provided" do
      @generator.should_receive(:open).with(@default_query).and_return(@default_response)
      @generator.sequence(1, 10)
    end
    
    it "hits random_org url with provided options" do
      @generator.should_receive(:open).with(get_url(@base_url,
                                             @default_params.merge({'max'=>33, 'min'=>21})) ).and_return(@default_response)
      @generator.sequence(21, 33)
    end
    
    it "returns an Array of integers" do
      @generator.sequence(1, 10).class.should == Array
      @generator.sequence(1, 10).size.should == 10
      @generator.sequence(1, 10).first.should == 8
    end
    
    it "raises an exception with the message from the server in case of a http error response" do
      exc = OpenURI::HTTPError.new("Error 503", StringIO.new("Wrong query params"))
      @generator.stub!(:open).and_raise(exc)
      lambda{@generator.sequence(0,-13000000)}.should raise_exception{|e| e.message.should == "Error from server: Wrong query params"}
    end
    
    it "is protected against sql injection" do
      @generator.should_receive(:open).with(@default_query).and_return(@default_response)
      @generator.sequence(1, "10\" OR 1=1")
    end
  end
  
  describe 'String generator' do
    before(:each) do
      @base_url = "http://www.random.org/strings/"
      @default_params = {'len' => 8, 
                         'digits' => 'on', 
                         'unique' => 'on', 
                         'upperalpha' => 'on',
                         'loweralpha' => 'on',
                         'rnd' => 'new', 
                         'format' => 'plain', 
                         'num' => 10 }
      @default_query = get_url(@base_url, @default_params)
      @default_response = "mfu0G89z\n azYZw48F\n qmcOUqIj\n TGytf0Hs\n 6f1jaYDC\n ExPLnE6N\n cWS3JoYW\n IGw2sCqm\n KpSsixvn\n Hw8F6oQC"
      @generator = RandomSources::RandomOrg.new
      @generator.stub!(:open).and_return(@default_response)
    end

    it "hits random_org url with default query if no options provided" do
      @generator.should_receive(:open).with(@default_query).and_return(@default_response)
      @generator.strings
    end
    
    it "hits random_org url with provided options" do
      @generator.should_receive(:open).with( get_url(@base_url,
                                             @default_params.merge({'len'=>50, 'digits'=>'off', 'num'=>7, 'unique'=>'off'})) ).and_return(@default_response)
      @generator.strings(:len => 50, :digits => 'off', :num => 7, :unique => 'off')
    end
    
    it "returns an Array of strings" do
      @generator.strings.class.should == Array
      @generator.strings.size.should == 10
      @generator.strings.first.should == "mfu0G89z"
      @generator.strings.last.should == "Hw8F6oQC"
    end
    
    it "raises an exception with the message from the server in case of a http error response" do
      exc = OpenURI::HTTPError.new("Error 503", StringIO.new("Wrong query params"))
      @generator.stub!(:open).and_raise(exc)
      lambda{@generator.strings(:len => -40)}.should raise_exception{|e| e.message.should == "Error from server: Wrong query params"}
    end
    
    it "do not let user modify format or rnd query params" do
      @generator.should_receive(:open).with( get_url(@base_url,
                                             @default_params.merge({'len'=>50, 'min'=>3, 'num'=>4, 'unique'=>'off'})) ).and_return(@default_response)
      @generator.strings(:len => 50, :digits => 'off', :num => 4, :unique => 'off', :rnd => 'changed', :format => 'html')
    end
    
    it "is protected against sql injection" do
      @generator.should_receive(:open).with(@default_query).and_return(@default_response)
      @generator.strings(:len => "100' OR 1=1")
    end
    
  end
  
  describe 'Quota checker' do
    before(:each) do
      @base_url = "http://www.random.org/quota/"
      @default_params = {'format' => 'plain'}
      @default_query = get_url(@base_url, @default_params)
      @default_response = "8983847\n"
      @generator = RandomSources::RandomOrg.new
      @generator.stub!(:open).and_return(@default_response)
    end
    
    it "hits random_org quota checker url" do
      @generator.should_receive(:open).with(@default_query).and_return(@default_response)
      @generator.quota
    end
    
    it "returns the number of bits available" do
      @generator.quota.should be_kind_of Integer
    end
    
    it "raises an exception with the message from the server in case of a http error response" do
      exc = OpenURI::HTTPError.new("Error 503", StringIO.new("Quota checker disabled for maintenance"))
      @generator.stub!(:open).and_raise(exc)
      lambda{@generator.quota}.should raise_exception{|e| e.message.should == "Error from server: Quota checker disabled for maintenance"}
    end
  end
    
  
end