require 'dkim_parse/parser'

module DKIMParse
  class Key

    attr_reader :v
    alias v version

    attr_reader :g
    alias g granularity

    attr_reader :h
    alias h hash

    attr_reader :k
    alias k key

    attr_reader :n
    alias n notes

    attr_reader :p
    alias p public_key

    attr_reader :s
    alias s service_type

    attr_reader :t
    alias t flags

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

    def self.parse(record)
      new(Parser.parse(record))
    end

  end
end
