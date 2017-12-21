require 'simplecov'
SimpleCov.start

require 'rspec'
require 'dkim/query'

include DKIM::Query

RSpec.configure do |specs|
  specs
end
