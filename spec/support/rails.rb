# Rails
ENV['RAILS_ENV'] = 'test'
require File.expand_path('../../../test_app/config/environment.rb',  __FILE__)
require 'rspec/rails'
Rails.backtrace_cleaner.remove_silencers!
