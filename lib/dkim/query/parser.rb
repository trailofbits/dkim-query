require 'parslet'
require 'openssl'

module DKIM
  module Query
    #
    # DKIM parser.
    #
    # @see https://tools.ietf.org/html/rfc6376#section-3
    #
    class Parser < Parslet::Parser

      root :record
      rule(:record) do
        (
          fws? >> key_tag >> fws? >>
          (str(';') >> fws? >> key_tag >> fws?).repeat(0) >> str(';').maybe
        ).as(:tag_list)
      end

      rule(:key_tag) do
        (
          key_v_tag |
          key_g_tag |
          key_h_tag |
          key_k_tag |
          key_n_tag |
          key_p_tag |
          key_s_tag |
          key_t_tag
        ).as(:tag)
      end

      private

      def self.key_tag_rule(name,&block)
        rule(:"key_#{name}_tag") do
          str(name).as(:name) >>
          fws? >> str('=') >> fws? >>
          instance_eval(&block).as(:value)
        end
      end

      def symbol(name)
        str(name).as(:symbol)
      end

      public

      key_tag_rule('v') { symbol('DKIM1') }
      key_tag_rule('g') { key_g_tag_lpart }
      rule(:key_g_tag_lpart) do
        (
          dot_atom_text.maybe >>
          (str('*') >> dot_atom_text.maybe).maybe
        ).as(:string)
      end
      rule(:dot_atom_text) do
        atext.repeat(1) >> (str('.') >> atext.repeat(1)).repeat(0)
      end

      key_tag_rule('h') do
        key_h_tag_alg >> (fws? >> str(':') >> fws? >> key_h_tag_alg).repeat(0)
      end
      rule(:key_h_tag_alg) { symbol('sha1') | symbol('sha256') | x_key_h_tag_alg }
      rule(:x_key_h_tag_alg) { hyphenated_word.as(:string) }

      key_tag_rule('k') { key_k_tag_type }
      rule(:key_k_tag_type) { symbol('rsa') | x_key_k_tag_type }
      rule(:x_key_k_tag_type) { hyphenated_word.as(:string) }

      key_tag_rule('n') { qp_section.as(:string) }
      key_tag_rule('p') { base64string.as(:asn1).maybe }
      key_tag_rule('s') do
        key_s_tag_type >> (fws? >> str(':') >> fws? >> key_s_tag_type).repeat(0)
      end
      rule(:key_s_tag_type) { symbol('email') | symbol('*') | x_key_s_tag_type }
      rule(:x_key_s_tag_type) { hyphenated_word.as(:string) }

      key_tag_rule('t') do
        key_t_tag_flag >> (fws? >> str(':') >> fws? >> key_t_tag_flag).repeat(0)
      end
      rule(:key_t_tag_flag) { match['ys'].as(:symbol) | x_key_t_tag_flag }
      rule(:x_key_t_tag_flag) { hyphenated_word.as(:string) }

      #
      # Section 2.6: DKIM-Quoted-Printable
      #
      rule(:dkim_quoted_printable) do
        (fws | hex_octet | dkim_safe_char).repeat(0)
      end
      rule(:dkim_safe_char) do
        match['\x21-\x3a'] | str("\x3c") | match['\x3e-\x7e']
      end

      #
      # Section 2.4: Common ABNF Tokens
      #
      rule(:hyphenated_word) do
        alpha >> (
          (str('-').absent? >> (alpha | digit)) |
          (str('-').repeat(0) >> (alpha | digit))
        ).repeat(0)
      end
      rule(:base64string) do
        (alpha | digit | str('+') | str('/') | fws).repeat(1) >>
        (str('=') >> fws? >> (str('=') >> fws?)).maybe
      end

      #
      # Section 2.3: Whitespace
      #
      rule(:sp)   { str(' ')    }
      rule(:crlf) { str("\r\n") }
      rule(:wsp)  { match['\t '] }
      rule(:wsp?) { wsp.maybe }
      rule(:lwsp) { (wsp | crlf >> wsp).repeat(0) }
      rule(:fws)  { (wsp.repeat(0) >> crlf).maybe >> wsp.repeat(1) }
      rule(:fws?) { fws.maybe }

      #
      # Character rules
      #
      rule(:alpha) { match['a-zA-Z'] }
      rule(:digit) { match['0-9'] }
      rule(:alnum) { match['a-zA-Z0-9'] }
      rule(:valchar) { match['\x21-\x3a'] | match['\x3c-\x7e'] }
      rule(:alnumpunc) { match['a-zA-Z0-9_'] }
      rule(:atext) { alnum | match['!#$%&\'*+\-/=?^ `{|}~'] }

      #
      # Quoted printable
      #
      rule(:qp_section) do
        (wsp? >> ptext.repeat(1) >> (wsp >> ptext.repeat(1)).repeat(0)).maybe
      end
      rule(:ptext) { hex_octet | safe_char }
      rule(:safe_char) { match['\x21-\x3c'] | match['\x3e-\x7e'] }
      rule(:hex_octet) { str('=') >> match['0-9A-F'].repeat(2,2) }

      class Transform < Parslet::Transform

        rule(:symbol => simple(:name)) { name.to_sym }
        rule(:string => simple(:text)) { text.to_s }
        # XXX: temporarily disable ASN1 decoding, due to an OpenSSL bug.
        # rule(:asn1 => simple(:blob)) { OpenSSL::ASN1.decode(blob) }
        rule(:asn1 => simple(:blob)) { blob }

        rule(tag: {name: simple(:name), value: subtree(:value)}) do
          {name.to_sym => value}
        end

        rule(tag_list: subtree(:hashes)) do
          case hashes
          when Array then hashes.reduce(&:merge!)
          else            hashes
          end
        end

      end

      #
      # Parses the text into structured data.
      #
      # @param [String] text
      #
      # @return [Hash]
      #
      def self.parse(text)
        Transform.new.apply(new.parse(text))
      end

    end
  end
end
