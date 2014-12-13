require 'pathname'

module Menagerie
  ##
  # Release object containing artifacts
  class Release
    def initialize(path, artifacts = nil)
      @path, @id = Pathname.new(path).split
      create(artifacts) if artifacts
    end

    def artifacts
      Dir.glob("#{@path}/#{@id}/*").map { |x| Artifact.new(x) }
    end
  end
end
