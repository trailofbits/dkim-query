require "codeclimate-test-reporter"
CodeClimate::TestReporter.start

require 'rspec'
require 'dkim_parse'

include DkimParse

RSpec.configure do |specs|
  specs
end