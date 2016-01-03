require File.dirname(__FILE__) + '/spec_helper'

describe RandomSources do

  describe 'General functions' do

    it "list of all the providers supported" do
      names=RandomSources.list.split(', ')
      expect(names.size).to be > 0
      names.each{|n|
        expect{RandomSources.const_get("#{n}").new}.to_not raise_exception
      }
    end

    it "instance of any generator class" do
      names=RandomSources.list.split(', ')
      names.each{|n|
        expect(RandomSources.generator("#{n}")).to be_instance_of RandomSources.const_get("#{n}")
      }
    end

  end
end
