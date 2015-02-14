require 'spec_helper'

describe Menagerie::Collection do
  let(:examples) { 'spec/examples' }
  let(:collection) { Menagerie.new }

  describe '#releases' do
    it 'parses releases in a collection' do
      Dir.chdir("#{examples}/existing") do
        expect(collection.releases.size).to eql 3
      end
    end

    it 'parses an empty collection as empty' do
      Dir.chdir("#{examples}/empty") do
        expect(collection.releases.size).to eql 0
      end
      Dir.chdir("#{examples}/empty_with_dirs") do
        expect(collection.releases.size).to eql 0
      end
    end

    it 'supports an alternate path for releases' do
      x = Menagerie.new paths: { releases: 'spec/examples/existing/releases' }
      expect(x.releases.size).to eql 3
    end
  end
end
