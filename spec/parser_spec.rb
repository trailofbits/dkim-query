require 'spec_helper'
require 'dkim/query/parser'

describe Parser do
  describe ".parse" do
    subject { described_class }

    let(:dkim) do
      %{k=rsa;  p=MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQDrEee0Ri4Juz+QfiWYui/E9UGSXau/2P8LjnTD8V4Unn+2FAZVGE3kL23bzeoULYv4PeleB3gfmJiDJOKU3Ns5L4KJAUUHjFwDebt0NP+sBK0VKeTATL2Yr/S3bT/xhy+1xtj4RkdV7fVxTn56Lb4udUnwuxK4V5b5PdOKj/+XcwIDAQAB; n=A 1024 bit key;}
    end

    it "should parse a DKIM record into a Hash" do
      expect(subject.parse(dkim)).to be == {
        k: :rsa,
        p: %{MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQDrEee0Ri4Juz+QfiWYui/E9UGSXau/2P8LjnTD8V4Unn+2FAZVGE3kL23bzeoULYv4PeleB3gfmJiDJOKU3Ns5L4KJAUUHjFwDebt0NP+sBK0VKeTATL2Yr/S3bT/xhy+1xtj4RkdV7fVxTn56Lb4udUnwuxK4V5b5PdOKj/+XcwIDAQAB},
        n: "A 1024 bit key;"
      }
    end
  end

  describe "tags" do
    describe "v" do
      subject { super().key_v_tag }

      it "should parse v=DKIM1" do
        expect(subject.parse('v=DKIM1')).to be == {
          name: 'v',
          value: {symbol: 'DKIM1'}
        }
      end
    end

    describe "g" do
      subject { super().key_g_tag }
    end

    describe "h" do
      subject { super().key_h_tag }

      it "should parse h=sha1" do
        expect(subject.parse('h=sha1')).to be == {
          name: 'h',
          value: {symbol: 'sha1'}
        }
      end

      it "should parse h=sha256" do
        expect(subject.parse('h=sha256')).to be == {
          name: 'h',
          value: {symbol: 'sha256'}
        }
      end

      it "should parse h=sha1:sha256" do
        expect(subject.parse('h=sha1:sha256')).to be == {
          name: 'h',
          value: [
            {symbol: 'sha1'},
            {symbol: 'sha256'}
          ]
        }
      end
    end

    describe "k" do
      subject { super().key_k_tag }

      it "should parse k=rsa" do
        expect(subject.parse('k=rsa')).to be == {
          name: 'k',
          value: {symbol: 'rsa'}
        }
      end
    end

    describe "n" do
      subject { super().key_n_tag }

      let(:notes) { %{A 1024 bit key} }

      it "should parse n=..." do
        expect(subject.parse("n=#{notes}")).to be == {
          name: 'n',
          value: notes
        }
      end
    end

    describe "p" do
      subject { super().key_p_tag }

      let(:base64) { %{MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQDrEee0Ri4Juz+QfiWYui/E9UGSXau/2P8LjnTD8V4Unn+2FAZVGE3kL23bzeoULYv4PeleB3gfmJiDJOKU3Ns5L4KJAUUHjFwDebt0NP+sBK0VKeTATL2Yr/S3bT/xhy+1xtj4RkdV7fVxTn56Lb4udUnwuxK4V5b5PdOKj/+XcwIDAQAB} }

      it "should parse p=..." do
        expect(subject.parse("p=#{base64}")).to be == {
          name: 'p',
          value: base64
        }
      end
    end

    describe "s" do
      subject { super().key_s_tag }

      it "should parse s=email" do
        expect(subject.parse('s=email')).to be == {
          name: 's',
          value: {symbol: 'email'}
        }
      end

      it "should parse s=*" do
        expect(subject.parse('s=*')).to be == {
          name: 's',
          value: {symbol: '*'}
        }
      end

      it "should parse s=email:*" do
        expect(subject.parse('s=email:*')).to be == {
          name: 's',
          value: [{symbol: 'email'}, {symbol: '*'}]
        }
      end
    end

    describe "t" do
      subject { super().key_t_tag }

      it "should parse t=y" do
        expect(subject.parse('t=y')).to be == {
          name: 't',
          value: 'y'
        }
      end

      it "should parse t=s" do
        expect(subject.parse('t=s')).to be == {
          name: 't',
          value: 's'
        }
      end
    end
  end

  describe "rules" do
    describe "dkim_quoted_printable" do
    end

    describe "dkim_safe_char" do
    end

    describe "hyphenated_word" do
    end

    describe "base64string" do
    end

    describe "qp_section" do
      subject { super().qp_section }

      it "should parse \"A\"" do
        expect(subject.parse('A')).to be == 'A'
      end

      it "should parse \"AAA\"" do
        expect(subject.parse('AAA')).to be == 'AAA'
      end

      it "should parse \" A\"" do
        expect(subject.parse(' A')).to be == ' A'
      end

      it "should parse \"A B\"" do
        expect(subject.parse('A B')).to be == 'A B'
      end

      it "should not parse \" \"" do
        expect {
          subject.parse(' ')
        }.to raise_error(Parslet::ParseFailed)
      end

      it "should not parse \"A \"" do
        expect {
          subject.parse('A ')
        }.to raise_error(Parslet::ParseFailed)
      end
    end

    describe "hex_octet" do
    end
  end

  describe Parser::Transform do
    context "when given {symbol: ...}" do
      let(:string) { 'foo' }

      it "should convert the string into a Symbol" do
        expect(subject.apply(symbol: string)).to be == string.to_sym
      end
    end

    context "when given {tag: {name: ..., value: ...}}" do
      let(:name)  { 'foo' }
      let(:value) { 'bar' }

      it "should convert the string into Hash" do
        expect(subject.apply(
          {tag: {name: name, value: value}}
        )).to be == {name.to_sym => value}
      end
    end

    context "when given {tag: {name: ..., value: [...]}}" do
      let(:name)  { 'foo' }
      let(:value) { ['a', 'b'] }

      it "should convert the string into Hash" do
        expect(subject.apply(
          {tag: {name: name, value: value}}
        )).to be == {name.to_sym => value}
      end
    end

    context "when {tag_list: {...}}" do
      let(:hash) { {foo: 'bar'} }

      it "should return the single Hash" do
        expect(subject.apply({tag_list: hash})).to be == hash
      end
    end

    context "when {tag_list: [{...}, ...]}" do
      let(:hashes) { [{foo: 'bar'}, {baz: 'quix'}] }
      let(:hash)   { {foo: 'bar', baz: 'quix'} }

      it "should merge the Hashes together" do
        expect(subject.apply({tag_list: hashes})).to be == hash
      end
    end
  end
end
