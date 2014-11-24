require "codeclimate-test-reporter"
CodeClimate::TestReporter.start

require 'rspec'
require 'dkim_parse'

include DKIMParse

RSpec.configure do |specs|
  specs
end