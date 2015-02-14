require 'spec_helper'

describe Menagerie::Release do
  before(:each) do
    FileUtils.rm_rf 'spec/examples/scratch'
    FileUtils.cp_r 'spec/examples/existing', 'spec/examples/scratch'
  end

  let(:base_path) { 'spec/examples/scratch' }
  let(:paths) do
    {
      artifacts: "#{base_path}/artifacts",
      releases: "#{base_path}/releases",
      latest: "#{base_path}/latest"
    }
  end
  let(:release) { Menagerie.new(paths: paths).releases.first }

  it 'has an id attribute' do
    expect(release.id).to eql '0'
  end

  it 'has a base attribute' do
    expect(release.base).to eql "#{base_path}/releases"
  end

  it 'has a path attribute' do
    expect(release.path).to eql "#{release.base}/#{release.id}"
  end

  it 'sorts' do
    other_release = Menagerie.new(paths: paths).releases.last
    expect(release <=> other_release).to eql(-1)
  end

  describe '#artifacts' do
    it 'is an array of Artifacts' do
      expect(release.artifacts).to all(be_a Menagerie::Artifact)
    end
  end

  describe '#rotate' do
    it 'rotates the release path' do
      last_release = Menagerie.new(paths: paths).releases.last
      expect(last_release.id).to eql '2'
      last_release.rotate
      expect(last_release.id).to eql '3'
    end
  end

  describe '#delete' do
    it 'deletes the release' do
      expect(Dir.exist? release.path).to be_truthy
      release.delete
      expect(Dir.exist? release.path).to be_falsey
    end
  end
end
