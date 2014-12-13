##
# This module provides release collection management
module Menagerie
  class << self
    ##
    # Insert a helper .new() method for creating a new Collection object

    def new(*args)
      self::Collection.new(*args)
    end
  end
end

require 'menagerie/artifact'
require 'menagerie/release'
require 'menagerie/collection'
