require 'cymbal'
require 'fileutils'

module Menagerie
  ##
  # Connection object that contains releases
  class Collection
    def initialize(params = {})
      params = Cymbal.symbolize(params || {})
      @paths = default_paths.merge(params[:paths] || {})
      @options = default_options.merge(params[:options] || {})
      @logger = Menagerie.get_logger(@options[:verbosity])
    end

    def releases
      Dir.glob("#{@paths[:releases]}/*").sort.map do |x|
        Release.new path: x, paths: @paths, logger: @logger
      end.sort
    end

    def orphans
      keepers = releases.map(&:artifacts).flatten.map(&:path).uniq
      Dir.glob("#{@paths[:artifacts]}/*/*").sort.reject do |artifact|
        keepers.include? artifact
      end
    end

    def add_release(artifacts)
      rotate
      Release.new(
        artifacts: Cymbal.symbolize(artifacts),
        paths: @paths,
        logger: @logger
      )
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
      orphans.each do |orphan|
        @logger.info "Reaping orphan: #{orphan}"
        FileUtils.rm_f orphan
      end
    end

    def link_latest
      FileUtils.rm_f @paths[:latest]
      FileUtils.ln_sf releases.sort.first.path, @paths[:latest]
      @logger.debug "Linked latest release to #{@paths[:latest]}"
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
        reap: true,
        verbose: true
      }
    end
  end
end
