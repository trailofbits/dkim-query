if ENV['CODECLIMATE_REPO_TOKEN']
  require "codeclimate-test-reporter"
  CodeClimate::TestReporter.start
end

require 'rspec'
require 'dkim_parse'

include DKIMParse

RSpec.configure do |specs|
  specs
end
