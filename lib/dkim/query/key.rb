require 'dkim/query/parser'
require 'dkim/query/malformed_key'

module DKIM
  module Query
    class Key

      attr_reader :v
      alias version v

      attr_reader :g
      alias granularity g

      attr_reader :h
      alias hash h

      attr_reader :k
      alias key k

      attr_reader :n
      alias notes n

      attr_reader :p
      alias public_key p

      attr_reader :s
      alias service_type s

      attr_reader :t
      alias flags t

      #
      # Initialize the key.
      #
      # @param [Hash{Symbol => Symbol,String}] tags
      #   Tags for the key.
      #
      # @option tags [Symbol] :v
      #
      # @option tags [Symbol] :g
      #
      # @option tags [Symbol] :h
      #
      # @option tags [Symbol] :k
      #
      # @option tags [Symbol] :n
      #
      # @option tags [Symbol] :p
      #
      # @option tags [Symbol] :s
      #
      # @option tags [Symbol] :t
      #
      def initialize(tags={})
        @v, @g, @h, @k, @n, @p, @s, @t = tags.values_at(:v,:g,:h,:k,:n,:p,:s,:t)
      end

      #
      # Parses a DKIM Key record.
      #
      # @param [String] record
      #   The DKIM key record.
      #
      # @return [Key]
      #   The new key.
      #
      # @raise [Parslet::ParseFailed]
      #   Could not parse the DKIM Key record.
      #
      def self.parse!(record)
        new(Parser.parse(record))
      end

      #
      # Parses a DKIM Key record.
      #
      # @param [String] record
      #   The DKIM key record.
      #
      # @return [Key, MalformedKey]
      #   The parsed key. If the key could not be parsed, a {MalformedKey}
      #   will be returned.
      #
      def self.parse(record)
        begin
          parse!(record)
        rescue Parslet::ParseFailed => error
          MalformedKey.new(record,error.cause)
        end
      end

      #
      # Converts the key to a Hash.
      #
      # @return [Hash{:v,:g,:h,:k,:n,:p,:s,:t => Object}]
      #
      def to_hash
        {
          v: @v,
          g: @g,
          h: @h,
          k: @k,
          n: @n,
          p: @p,
          s: @s,
          t: @t
        }
      end

      #
      # Converts the key back into a DKIM String.
      #
      # @return [String]
      #
      def to_s
        tags = []

        tags << "v=#{@v}" if @v
        tags << "g=#{@g}" if @g
        tags << "h=#{@h}" if @h
        tags << "k=#{@k}" if @k
        tags << "p=#{@p}" if @p
        tags << "s=#{@s}" if @s
        tags << "t=#{@t}" if @t
        tags << "n=#{@n}" if @n

        return tags.join('; ')
      end

    end
  end
end
