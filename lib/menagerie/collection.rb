require 'cymbal'

module Menagerie
  ##
  # Connection object that contains releases
  class Collection
    def initialize(params = {})
      params = Cymbal.symbolize params
      @paths = default_paths.merge(params[:paths] || {})
      @options = default_options.merge(params[:options] || {})
    end

    def releases
      Dir.glob("#{@paths[:releases]}/*").map do |x|
        Release.new path: x
      end
    end

    def create(artifacts)
      rotate
      Release.new artifacts: artifacts, paths: @paths
      reap if @options[:reap]
      link_latest
    end

    private

    def rotate
      existing = releases.reverse.sort
      existing.pop(existing.size - @options[:retention]).each(&:delete)
      existing.each(&:rotate)
    end

    def reap
    end

    def link_latest
      FileUtils.ln_sf releases.sort.first.path, "#{@paths[:latest]}"
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
