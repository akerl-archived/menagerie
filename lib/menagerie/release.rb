require 'pathname'
require 'fileutils'

module Menagerie
  ##
  # Release object containing artifacts
  class Release
    attr_reader :id, :base, :path

    def initialize(params = {})
      @options = params
      @logger = @options[:logger] || Menagerie.get_logger
      @path = @options[:path] || create
      parse_path
    end

    def artifacts
      Dir.glob("#{@path}/*").map do |x|
        Artifact.new path: x, paths: @options[:paths], logger: @logger
      end
    end

    def <=>(other)
      return nil unless other.is_a? Release
      @id.to_i <=> other.id.to_i
    end

    def rotate
      old_path = @path
      @path = "#{@base}/#{@id.to_i + 1}"
      FileUtils.mv old_path, @path
      parse_path
    end

    def delete
      @logger.info "Deleting release: #{@path}"
      FileUtils.rm_r @path
    end

    private

    def create
      path = "#{@options[:paths][:releases]}/0"
      @logger.info "Creating release: #{path}"
      FileUtils.mkdir_p path
      @options[:artifacts].each do |x|
        artifact = Artifact.new(
          artifact: x, paths: @options[:paths], logger: @logger
        )
        link artifact.path, "#{path}/#{x[:name]}"
      end
      path
    end

    def link(source, target)
      target_dir = Pathname.new(target).dirname
      relative_source = Pathname.new(source).relative_path_from(target_dir)
      FileUtils.ln_s relative_source, target
    end

    def parse_path
      @base, @id = Pathname.new(@path).split.map(&:to_s)
    end
  end
end
