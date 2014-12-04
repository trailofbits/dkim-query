require 'spec_helper'
require 'dkim/query/keys'

describe Keys do
  describe "#initialize" do
    let(:domain) { 'yahoo.com' }
    let(:key) do
      Key.new(
        k: :rsa,
        p: "MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQDrEee0Ri4Juz+QfiWYui/E9UGSXau/2P8LjnTD8V4Unn+2FAZVGE3kL23bzeoULYv4PeleB3gfmJiDJOKU3Ns5L4KJAUUHjFwDebt0NP+sBK0VKeTATL2Yr/S3bT/xhy+1xtj4RkdV7fVxTn56Lb4udUnwuxK4V5b5PdOKj/+XcwIDAQAB",
        n: "A 1024 bit key;",
      )
    end
    let(:keys) { {'s1024' => key} }

    subject { described_class.new(domain,keys) }

    it "should set name" do
      expect(subject.name).to be domain
    end

    it "should set keys" do
      expect(subject.keys).to be keys
    end
  end

  describe ".parse" do
    let(:domain) { 'yahoo.com' }
    let(:key) do
      %{k=rsa;  p=MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQDrEee0Ri4Juz+QfiWYui/E9UGSXau/2P8LjnTD8V4Unn+2FAZVGE3kL23bzeoULYv4PeleB3gfmJiDJOKU3Ns5L4KJAUUHjFwDebt0NP+sBK0VKeTATL2Yr/S3bT/xhy+1xtj4RkdV7fVxTn56Lb4udUnwuxK4V5b5PdOKj/+XcwIDAQAB; n=A 1024 bit key}
    end
    let(:keys) { {'s1024' => key} }

    subject { described_class.parse(domain,keys) }

    it "should parse the keys" do
      expect(subject.keys['s1024']).to be_kind_of(Key)
    end
  end

  describe ".query" do
    let(:domain) { 'yahoo.com' }

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

    let(:domain) { "google.com" }
    let(:tld)    { ".com" }

    it "should strip the last component of the domain" do
      expect(subject.host_without_tld(domain)).to be == domain.chomp(tld)
    end
  end

  describe ".selectors_for" do
    let(:domain) { "google.com" }

    subject { described_class.selectors_for(domain) }

    described_class::SELECTORS.each do |selector|
      it "should include '#{selector}'" do
        expect(subject).to include(selector)
      end
    end

    it "should include the domain without the TLD" do
      expect(subject).to include('google')
    end
  end
end
