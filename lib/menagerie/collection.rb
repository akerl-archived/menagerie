require 'cymbal'

module Menagerie
  ##
  # Connection object that contains releases
  class Collection
    def initialize(params = {})
      @config = Cymbal.symbolize params
      @paths = default_paths.merge(@config[:paths] || {})
      @options = default_options.merge(@config[:options] || {})
    end

    def releases
      Dir.glob("#{@paths[:releases]}/*").map { |x| Release.new(x) }
    end

    private

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
