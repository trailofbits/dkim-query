require 'dkim/query/query'
require 'dkim/query/key'

require 'resolv'

module DKIM
  module Query
    #
    # Represents the DKIM keys of a domain.
    #
    class Domain

      include Enumerable

      # Name of the domain
      #
      # @return [String]
      attr_reader :name

      # DKIM Keys of the domain
      #
      # @return [Hash{String => Key}]
      attr_reader :keys

      #
      # Initializes the domain.
      #
      # @param [String] name
      #   The domain name.
      #
      # @param [Hash{String => Key}] keys
      #   The DKIM Keys of the domain.
      #
      # @api public
      #
      def initialize(name,keys={})
        @name = name
        @keys = keys
      end

      #
      # Parses the DKIM Keys.
      #
      # @param [String] domain
      #   The domain the keys belong to.
      #
      # @param [Hash{String => String}] keys
      #   The DKIM selectors and keys.
      #
      # @return [Domain]
      #   The domain and it's parsed DKIM keys.
      #
      # @api semipublic
      #
      def self.parse(domain,keys={})
        keys = Hash[keys.map { |selector,record|
          [selector, Key.parse(record)]
        }]

        return new(domain,keys)
      end

      #
      # Parses the DKIM Keys.
      #
      # @param [String] domain
      #   The domain the keys belong to.
      #
      # @param [Hash{String => String}] keys
      #   The DKIM selectors and keys.
      #
      # @return [Domain]
      #   The domain and it's parsed DKIM keys.
      #
      # @raise [Parslet::ParseFailed]
      #   One of the keys was invalid.
      #
      # @api semipublic
      #
      def self.parse!(domain,keys={})
        keys = Hash[keys.map { |selector,record|
          [selector, Key.parse!(record)]
        }]

        return new(domain,keys)
      end

      #
      # Queries the domain for all DKIM selectors.
      #
      # @param [String] domain
      #   The domain to query.
      #
      # @option options [Array<String>] :selectors
      #   sub-domain selectors.
      #
      # @option options [Resolv::DNS] :resolver
      #
      # @return [Domain]
      #   The domain and it's DKIM Keys.
      #
      # @api public
      #
      def self.query(domain,options={})
        parse(domain,Query.query(domain,options))
      end

      #
      # Enumerates over each individual key.
      #
      # @yield [key]
      #   The given block will be passed each key.
      #
      # @yieldparam [DKIM::Query::Key] key
      #   A key belonging to the domain.
      #
      # @return [Enumerator]
      #   If no block was given, an Enumerator will be returned.
      #
      # @api public
      #
      def each(&block)
        @keys.each_value(&block)
      end

      #
      # Selects a key from the domain.
      #
      # @param [String] selector 
      #   The selector.
      #
      # @return [Key, nil]
      #   The key within that selector.
      #
      def [](selector)
        @keys[selector]
      end

    end
  end
end
