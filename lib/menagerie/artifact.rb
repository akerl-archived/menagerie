require 'pathname'
require 'open-uri'

module Menagerie
  ##
  # Artifacts are a stored file for a particular version of a project
  class Artifact
    attr_reader :version, :name, :path

    def initialize(params = {})
      @config = params
      @logger = @config[:logger] || Menagerie.get_logger
      parse @config.fetch(:artifact, {})
      create if @config[:artifact]
    end

    private

    def create
      @logger.info "Downloading artifact: #{@path}"
      download(@config[:artifact][:url], path) unless File.exist? path
      File.chmod(@config[:artifact][:mode], path) if @config[:artifact][:mode]
    end

    def parse(params = {})
      @name = params[:name] || Pathname.new(@config[:path]).basename
      @version = params[:path] || File.basename(File.readlink(@config[:path]))
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
