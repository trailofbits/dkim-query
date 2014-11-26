require 'dkim_parse/parser'

module DKIMParse
  class Key

    attr_reader :v

    attr_reader :g

    attr_reader :h

    attr_reader :k

    attr_reader :n

    attr_reader :p

    attr_reader :s

    attr_reader :t

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
