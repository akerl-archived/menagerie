require 'spec_helper'

describe Menagerie::Artifact do
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
  let(:new_artifact) do
    { name: 'a', version: '2.0.0', url: 'https://goo.gl/pWew5I' }
  end
  let(:produce_output) do
    output(/Downloading artifact/).to_stdout_from_any_process
  end
  let(:artifact) { Menagerie.new(paths: paths).releases.first.artifacts.first }

  it 'has a name attribute' do
    expect(artifact.name).to eql 'a'
  end

  it 'has a version attribute' do
    expect(artifact.version).to eql '0.0.3'
  end

  it 'has a path attribute' do
    expect(artifact.path).to eql "#{base_path}/artifacts/a/0.0.3"
  end

  it 'is created if it does not exist' do
    expect(File.exist?("#{base_path}/artifacts/a/2.0.0")).to be_falsey
    params = { paths: paths, artifact: new_artifact }
    expect { Menagerie::Artifact.new params }.to produce_output
    expect(File.exist?("#{base_path}/artifacts/a/2.0.0")).to be_truthy
  end
end
