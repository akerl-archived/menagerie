require 'open-uri'

module Menagerie
  ##
  # Artifacts are a stored file for a particular version of a project
  class Artifact
    attr_reader :name, :version

    def initialize(params = {})
      @options = params
      @logger = @options[:logger] || Menagerie.get_logger
      @options[:artifact] ? create : parse
    end

    def path
      @path ||= "#{@options[:paths][:artifacts]}/#{@name}/#{@version}"
    end

    private

    def create
      artifact = @options[:artifact]
      @name, @version = artifact.values_at(:name, :version)
      @logger.info "Downloading artifact: #{path}"
      download(artifact[:url], path) unless File.exist? path
      File.chmod(artifact[:mode], path) if artifact[:mode]
    end

    def parse
      @name = File.basename @options[:path]
      @version = File.basename File.readlink(@options[:path])
    end

    def download(url, path)
      FileUtils.mkdir_p File.dirname(path)
      File.open(path, 'wb') do |fh|
        open(url, 'rb') { |request| fh.write request.read }
      end
    end
  end
end
