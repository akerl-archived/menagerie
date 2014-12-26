require 'cymbal'
require 'fileutils'

module Menagerie
  ##
  # Connection object that contains releases
  class Collection
    def initialize(params = nil)
      params = Cymbal.symbolize(params || {})
      @paths = default_paths.merge(params[:paths] || {})
      @options = default_options.merge(params[:options] || {})
    end

    def releases
      Dir.glob("#{@paths[:releases]}/*").map do |x|
        Release.new path: x, paths: @paths
      end
    end

    def create(artifacts)
      rotate
      Release.new artifacts: Cymbal.symbolize(artifacts), paths: @paths
      reap if @options[:reap]
      link_latest
    end

    private

    def rotate
      existing = releases.sort.reverse
      keepers = existing.pop(@options[:retention])
      existing.each(&:delete)
      keepers.each(&:rotate)
    end

    def reap
      keepers = releases.map(&:artifacts).flatten.map(&:path).uniq
      Dir.glob("#{@paths[:artifacts]}/*/*").each do |artifact|
        FileUtils.rm_f(artifact) unless keepers.include? artifact
      end
    end

    def link_latest
      FileUtils.rm_f @paths[:latest]
      FileUtils.ln_sf releases.sort.first.path, @paths[:latest]
    end

    def default_paths
      {
        artifacts: 'artifacts',
        releases: 'releases',
        latest: 'latest'
      }
    end

    def default_options
      {
        retention: 5,
        reap: true
      }
    end
  end
end
