require 'pathname'
require 'open-uri'

module Menagerie
  ##
  # Artifacts are a stored file for a particular version of a project
  class Artifact
    attr_reader :version, :name, :path

    def initialize(params = {})
      @options = params
      @logger = @options[:logger] || Menagerie.get_logger
      parse @options.fetch(:artifact, {})
      create if @options[:artifact]
    end

    private

    def create
      @logger.info "Downloading artifact: #{@path}"
      download(@options[:artifact][:url], path) unless File.exist? path
      File.chmod(@options[:artifact][:mode], path) if @options[:artifact][:mode]
    end

    def parse(params = {})
      @name = params[:name] || Pathname.new(@options[:path]).basename
      @version = params[:path] || File.basename(File.readlink(@options[:path]))
      @path = "#{@options[:paths][:artifacts]}/#{@name}/#{@version}"
    end

    def download(url, path)
      FileUtils.mkdir_p File.dirname(path)
      File.open(path, 'wb') do |fh|
        open(url, 'rb') { |request| fh.write request.read }
      end
    end
  end
end
