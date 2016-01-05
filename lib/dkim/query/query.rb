require 'resolv'

module DKIM
  module Query
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
    #   Optional resolver to use.
    #
    # @return [Hash{String => String}]
    #   The DKIM keys for the domain.
    #
    # @api semipublic
    #
    def self.query(domain,options={})
      selectors = options.fetch(:selectors) { selectors_for(domain) }
      resolver  = options.fetch(:resolver)  { Resolv::DNS.new }

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

      return keys
    end

    # Default known selectors
    SELECTORS = %w[default dkim s1024 c1211 mandrill]

    #
    # DKIM query selectors for the host.
    #
    # @param [String] host
    #
    # @return [Array<String>]
    #
    # @api private
    #
    def self.selectors_for(host)
      SELECTORS + [host_without_tld(host)]
    end

    #
    # Removes the TLD from the hostname.
    #
    # @param [String] host
    #
    # @return [String]
    #
    # @api private
    #
    def self.host_without_tld(host)
      if host.include?('.') then host[0,host.rindex('.')]
      else                       host
      end
    end

  end
end
