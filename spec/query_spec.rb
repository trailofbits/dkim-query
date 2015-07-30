require 'spec_helper'
require 'dkim/query/query'

describe DKIM::Query do
  subject { described_class }

  let(:domain) { 'yahoo.com' }

  describe ".host_without_tld" do
    let(:tld) { ".com" }

    it "should strip the last component of the domain" do
      expect(subject.host_without_tld(domain)).to be == domain.chomp(tld)
    end

    context "when given a host with no tld" do
      let(:domain) { 'test' }

      it "should return the full host" do
        expect(subject.host_without_tld(domain)).to be == domain
      end
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

  describe ".query" do
    it "should return all found DKIM keys" do
      expect(subject.query(domain)).to be == {
        's1024' => 'k=rsa;  p=MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQDrEee0Ri4Juz+QfiWYui/E9UGSXau/2P8LjnTD8V4Unn+2FAZVGE3kL23bzeoULYv4PeleB3gfmJiDJOKU3Ns5L4KJAUUHjFwDebt0NP+sBK0VKeTATL2Yr/S3bT/xhy+1xtj4RkdV7fVxTn56Lb4udUnwuxK4V5b5PdOKj/+XcwIDAQAB; n=A 1024 bit key;'
      }
    end

    context "with custom selectors" do
      let(:selectors) { ['google', 's1024'] }

      it "should query those selectors only" do
        expect(subject.query(domain, selectors: selectors)).to have_key('s1024')
      end
    end

    context "with no selectors" do
      it "should not find any keys" do
        expect(subject.query(domain, selectors: [])).to be_empty
      end
    end

    context "when given an invalid domain" do
      let(:domain) { 'foo.bar.com' }

      it "should return {}" do
        expect(subject.query(domain)).to be == {}
      end
    end
  end
end
