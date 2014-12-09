require 'dkim/query/parser'

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
      def self.parse(record)
        new(Parser.parse(record))
      end

      #
      # Queries and parses the DKIM record.
      #
      # @param [String] domain
      #   The domain containing the DKIM record.
      #
      # @param [Resolv::DNS] resolver
      #   Optional resolver to use.
      #
      # @return [Key, nil]
      #   The parsed key, or `nil` if no DKIM record could be found.
      #
      def self.query(domain,resolver=Resolv::DNS.new)
        begin
          dkim = resolver.getresource(
            domain, Resolv::DNS::Resource::IN::TXT
          ).strings.join

          return parse(dkim)
        rescue Resolv::ResolvError
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

    end
  end
end
