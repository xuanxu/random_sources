require File.dirname(__FILE__) + '/spec_helper'

describe RandomSources::HotBits do

  describe 'Bytes generator' do

    before(:each) do
      @base_url = "https://www.fourmilab.ch/cgi-bin/Hotbits"
      @default_params = {'fmt' => 'xml', 'nbytes'=> 10}
      @default_query = get_url(@base_url, @default_params)
      @generator = RandomSources::HotBits.new
      allow(@generator).to receive(:open) { File.new("#{$data_samples_path}/hotbits_ok.xml") }
    end

    it "hits hotbits generator url with default query if no options provided" do
      expect(@generator).to receive(:open).with(@default_query)
      @generator.bytes
    end

    it 'parses information from hotbits server response' do
      expect(@generator.bytes).to include "A7".hex
    end

    it "hits hotbits generator url with provided param" do
      expect(@generator).to receive(:open).with( get_url(@base_url, @default_params.merge({'nbytes' => 5})))
      @generator.bytes(5)
    end

    it "returns an Array of byte-integers (0 - 255)" do
      response = @generator.bytes
      expect(response.class).to eq(Array)
      expect(response.size).to be > 0
      response.each{|n| expect(n).to be <= 255}
      response.each{|n| expect(n).to be  >= 0}
    end

    it "raises an exception with the message from the server in case of a http 503 response" do
      allow(@generator).to receive(:open) {File.new("#{$data_samples_path}/hotbits_nok.xml")}
      expect{@generator.bytes}.to raise_exception{|e| expect(e.message).to eq("You have exceeded your 24-hour quota for HotBits.")}
    end
  end

end