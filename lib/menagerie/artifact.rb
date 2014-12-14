require 'pathname'
require 'open-uri'

module Menagerie
  ##
  # Artifacts are a stored file for a particular version of a project
  class Artifact
    attr_reader :version, :name, :path

    def initialize(params = {})
      @config = params
      @config[:artifact] ? create : parse
    end

    private

    def create
      @name, @version, url = @config[:artifact].values_at :name, :version, :url
      @path = "#{@config[:paths][:artifacts]}/#{@name}/#{@version}"
      download url, path unless File.exist? path
      File.chmod(@config[:artifact][:mode], path) if @config[:artifact][:mode]
    end

    def parse
      link_path = @config[:path]
      @name = Pathname.new(link_path).basename
      @version = File.basename File.readlink(link_path)
      @path = "#{@config[:paths][:artifacts]}/#{@name}/#{@version}"
    end

    def download(url, path)
      FileUtils.mkdir_p File.dirname(path)
      File.open(path, 'wb') do |fh|
        open(url, 'rb') { |request| fh.write request.read }
      end
    end
  end
end
