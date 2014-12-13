module Menagerie
  ##
  # Artifacts are a stored file for a particular version of a project
  class Artifact
    def initialize(path)
      @path, @name = Pathname.new(path).split
      @version = File.basename File.readlink(path)
    end
  end
end
