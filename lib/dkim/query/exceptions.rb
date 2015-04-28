require 'parslet'

module DKIM
  module Query
    class InvalidKey < Parslet::ParseFailed
    end
  end
end
