require 'spec_helper'
require 'dkim/query/malformed_key'

describe MalformedKey do
  describe "#to_s" do
    let(:value) { "foo bar" }
    let(:cause) { double(:parslet_error) }

    subject { described_class.new(value,cause) }

    it "should return the value" do
      expect(subject.to_s).to be == value
    end
  end
end
