$:.unshift File.expand_path('../../lib', __FILE__)
require 'opal-rails'

require 'support/rails'
require 'support/capybara'
require 'support/cache'

RSpec.configure do |config|
  config.mock_with :rspec
  config.treat_symbols_as_metadata_keys_with_true_values = true
end
