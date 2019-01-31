ENV['RAILS_ENV'] ||= 'test'
require "dotenv"
Dotenv.load
require_relative '../config/environment'
require 'rails/test_help'
require "mocha/minitest"

Dir[Rails.root.join("test/support/**/*.rb")].each { |file| require file }

class ActiveSupport::TestCase
end
