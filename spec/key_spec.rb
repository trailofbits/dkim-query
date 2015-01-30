require 'spec_helper'
require 'dkim/query/key'

describe Key do
  let(:k) { :rsa }
  let(:p) { "MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQDrEee0Ri4Juz+QfiWYui/E9UGSXau/2P8LjnTD8V4Unn+2FAZVGE3kL23bzeoULYv4PeleB3gfmJiDJOKU3Ns5L4KJAUUHjFwDebt0NP+sBK0VKeTATL2Yr/S3bT/xhy+1xtj4RkdV7fVxTn56Lb4udUnwuxK4V5b5PdOKj/+XcwIDAQAB" }
  let(:n) { "A 1024 bit key;" }

  subject do
    described_class.new(
      k: k,
      p: p,
      n: n
    )
  end

  describe "#initialize" do
    it "should set @k" do
      expect(subject.k).to be k
    end

    it "should set @p" do
      expect(subject.p).to be p
    end

    it "should set @n" do
      expect(subject.n).to be n
    end
  end

  describe ".parse" do
    let(:record) do
      %{k=rsa;  p=MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQDrEee0Ri4Juz+QfiWYui/E9UGSXau/2P8LjnTD8V4Unn+2FAZVGE3kL23bzeoULYv4PeleB3gfmJiDJOKU3Ns5L4KJAUUHjFwDebt0NP+sBK0VKeTATL2Yr/S3bT/xhy+1xtj4RkdV7fVxTn56Lb4udUnwuxK4V5b5PdOKj/+XcwIDAQAB; n=A 1024 bit key}
    end

    subject { described_class.parse(record) }

    it "should return a Key" do
      expect(subject).to be_kind_of(described_class)
    end
  end

  describe "#to_hash" do
    subject { super().to_hash }

    it "should include :k" do
      expect(subject[:k]).to be == k
    end

    it "should include :p" do
      expect(subject[:p]).to be == p
    end

    it "should include :n" do
      expect(subject[:n]).to be == n
    end
  end
end
