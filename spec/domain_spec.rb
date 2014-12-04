require 'spec_helper'
require 'dkim/query/domain'

describe Domain do
  let(:domain) { 'yahoo.com' }
  let(:key) do
    Key.new(
      k: :rsa,
      p: "MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQDrEee0Ri4Juz+QfiWYui/E9UGSXau/2P8LjnTD8V4Unn+2FAZVGE3kL23bzeoULYv4PeleB3gfmJiDJOKU3Ns5L4KJAUUHjFwDebt0NP+sBK0VKeTATL2Yr/S3bT/xhy+1xtj4RkdV7fVxTn56Lb4udUnwuxK4V5b5PdOKj/+XcwIDAQAB",
      n: "A 1024 bit key;",
    )
  end
  let(:selector) { 's1024' }
  let(:keys) { {selector => key} }

  subject { described_class.new(domain,keys) }

  describe "#initialize" do
    it "should set name" do
      expect(subject.name).to be domain
    end

    it "should set keys" do
      expect(subject.keys).to be keys
    end
  end

  describe ".parse" do
    let(:key) do
      %{k=rsa;  p=MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQDrEee0Ri4Juz+QfiWYui/E9UGSXau/2P8LjnTD8V4Unn+2FAZVGE3kL23bzeoULYv4PeleB3gfmJiDJOKU3Ns5L4KJAUUHjFwDebt0NP+sBK0VKeTATL2Yr/S3bT/xhy+1xtj4RkdV7fVxTn56Lb4udUnwuxK4V5b5PdOKj/+XcwIDAQAB; n=A 1024 bit key}
    end
    let(:keys) { {selector => key} }

    subject { described_class.parse(domain,keys) }

    it "should parse the keys" do
      expect(subject.keys[selector]).to be_kind_of(Key)
    end
  end

  describe ".query" do
    subject { described_class.query(domain) }

    it "should find all known keys" do
      expect(subject.keys).to have_key('s1024')
    end

    context "with custom selectors" do
      let(:selectors) { ['google', 's1024'] }

      subject { described_class.query(domain, selectors: selectors) }

      it "should query those selectors only" do
        expect(subject.keys).to have_key('s1024')
      end
    end

    context "with no selectors" do
      let(:selectors) { [] }

      subject { described_class.query(domain, selectors: selectors) }

      it "should not find any keys" do
        expect(subject.keys).to be_empty
      end
    end
  end

  describe ".host_without_tld" do
    subject { described_class }

    let(:tld)    { ".com" }

    it "should strip the last component of the domain" do
      expect(subject.host_without_tld(domain)).to be == domain.chomp(tld)
    end
  end

  describe ".selectors_for" do
    subject { described_class.selectors_for(domain) }

    described_class::SELECTORS.each do |selector|
      it "should include '#{selector}'" do
        expect(subject).to include(selector)
      end
    end

    it "should include the domain without the TLD" do
      expect(subject).to include('yahoo')
    end
  end

  describe "#each" do
    context "when given a block" do
      it "should yield each Key" do
        expect { |b| subject.each(&b) }.to yield_with_args(key)
      end
    end

    context "when not given a block" do
      it "should return an Enumerator" do
        expect(subject.each).to be_kind_of(Enumerator)
      end
    end
  end

  describe "#[]" do
    context "when given a valid selector" do
      it "should return the key" do
        expect(subject[selector]).to be key
      end
    end

    context "when given an unknown selector" do
      it "should return nil" do
        expect(subject['foo']).to be_nil
      end
    end
  end
end
