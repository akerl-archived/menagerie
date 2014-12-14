require 'pathname'
require 'open-uri'

module Menagerie
  ##
  # Artifacts are a stored file for a particular version of a project
  class Artifact
    attr_reader :version, :name, :base, :path

    def initialize(params = {})
      @config = params
      @path = @config[:path] || create
      @base, @name = Pathname.new(path).split.map(&:to_s)
      @version = File.basename File.readlink(path)
    end

    def create
      name, version, url = @config[:artifact].values_at :name, :version, :url
      path = "#{@config[:paths][:artifacts]}/#{name}/#{version}"
      download url, path unless File.exist? path
      File.chmod(@config[:artifact][:mode], path) if @config[:artifact][:mode]
      path
    end

    private

    def download(url, path)
      FileUtils.mkdir_p File.dirname(path)
      File.open(path, 'wb') do |fh|
        open(url, 'rb') { |request| fh.write request.read }
      end
    end
  end
end
