require 'rspec'
require 'rack/test'
require './application'

def app
  Sinatra::Application
end

RSpec.configure do |conf|
  conf.include Rack::Test::Methods
end
