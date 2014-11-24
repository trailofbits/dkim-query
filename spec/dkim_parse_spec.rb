require 'spec_helper'
require 'dkim_parse'

describe DKIMParse do
  describe "dkim" do
    context "when given a domain which we know to have a DKIM record" do
      let(:domain) { 'trailofbits.com' }

      it "should return a hash containing the DKIM record and path where it was found" do
        dkim = DKIMParse.check_host(domain)

        expect(dkim).to be_kind_of(Hash)
        expect(dkim[:record_path]).to eq("trailofbits._domainkey.trailofbits.com")
        puts "  - record path: #{dkim[:record_path]}"
        puts "  - record: #{dkim[:record]}"
      end
    end

    context "when given a domain which does not have a DKIM record" do
      let(:domain) { 'fsho.trailofbits.com' }

      it "should return nil" do
        dkim = DKIMParse.check_host(domain)
        expect(dkim).to eq(nil)
      end
    end

    context "when given a bad domain" do
      it "should raise an error explaining that the domain was malformed" do
        expect {
          DKIMParse.check_host('qwerty')
        }.to raise_error
      end
    end
  end
end
