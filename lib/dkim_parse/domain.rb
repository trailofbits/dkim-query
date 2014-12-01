require 'dkim_parse/key'

require 'resolv'

module DKIMParse
  class Domain

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

        begin
          keys[selector] = resolver.getresource(
            host, Resolv::DNS::Resource::IN::TXT
          ).strings.join
        rescue Resolv::ResolvError
        end
      end

      return parse(domain,keys)
    end

  end
end
