module DKIM
  module Query
    #
    # Represents a unparsable DKIM key.
    #
    class MalformedKey

      # Raw value of the DKIM key.
      #
      # @return [String]
      attr_reader :value

      # Cause of the parser failure.
      #
      # @return [Parslet::Cause]
      attr_reader :cause

      #
      # Initializes the malformed key.
      #
      # @param [String] value
      #   The raw DKIM key.
      #
      # @param [Parslet::Cause] cause
      #   The cause of the parser failure.
      #
      def initialize(value,cause)
        @value = value
        @cause = cause
      end

      alias to_s value

    end
  end
end
