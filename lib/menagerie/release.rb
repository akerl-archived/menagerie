require 'pathname'
require 'fileutils'

module Menagerie
  ##
  # Release object containing artifacts
  class Release
    attr_reader :id, :base, :path

    def initialize(params = {})
      @config = params
      @path = @config[:path] || create
      @base, @id = Pathname.new(@path).split.map(&:to_s)
    end

    def artifacts
      Dir.glob("#{@path}/*").map { |x| Artifact.new(path: x) }
    end

    def <=>(other)
      return nil unless other.is_a? Release
      @id.to_i <=> other.id.to_i
    end

    def create
      path = "#{@config[:paths][:releases]}/0"
      FileUtils.mkdir path
      @config[:artifacts].each do |x|
        artifact = Artifact.new artifact: x, paths: @paths
        link artifact.path, "#{path}/#{x[:name]}"
      end
      path
    end

    def link(source, target)
      target_dir = Pathname.new(target).dirname
      relative_source = Pathname.new(source).relative_path_from(target_dir)
      FileUtil.ln_s relative_source, target
    end

    def rotate
      FileUtils.mv @path, "#{@base}/#{@id.to_i + 1}"
    end

    def delete
      FileUtils.rm_r @path
    end
  end
end
