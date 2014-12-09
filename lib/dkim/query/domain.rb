require 'dkim/query/key'

require 'resolv'

module DKIM
  module Query
    class Domain

      include Enumerable

      # Default known selectors
      SELECTORS = %w[default dkim s1024]

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
      # @api private
      #
      def self.selectors_for(host)
        SELECTORS + [host_without_tld(host)]
      end

      #
      # @api private
      #
      def self.host_without_tld(host)
        host[0,host.rindex('.')]
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
        selectors = options.fetch(:selectors) do
          selectors=selectors_for(domain)
        end
        resolver = options.fetch(:resolver) { Resolv::DNS.new }

        keys = {}

        selectors.each do |selector|
          host = "#{selector}._domainkey.#{domain}"

          keys[selector] = Key.query(host)
        end

        return new(domain,keys)
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
